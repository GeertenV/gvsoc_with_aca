#include <vp/vp.hpp>
#include <vp/itf/io.hpp>
#include <queue>
#include <tuple>

class AcaModule : public vp::Component
{

public:
    AcaModule(vp::ComponentConf &config);

private:
    static vp::IoReqStatus handle_req(vp::Block *__this, vp::IoReq *req);
    static void handle_event(vp::Block *__this, vp::ClockEvent *event);
    void read_scratchpad();

    vp::IoSlave input_itf;
    vp::ClockEvent event;
    vp::Trace trace;
    vp::WireMaster<int> set_itf;

    uint32_t latency;

    uint32_t row_count;
    uint32_t col_count;

    uint8_t row_start;
    uint8_t row_stride;
    uint8_t row_cycles;
    uint8_t col_start;
    uint8_t col_stride;
    uint8_t col_cycles;

    std::queue<std::tuple<int, int>> queue;

};

AcaModule::AcaModule(vp::ComponentConf &config)
    : vp::Component(config), event(this, AcaModule::handle_event)
{
    this->input_itf.set_req_meth(&AcaModule::handle_req);
    this->new_slave_port("input", &this->input_itf);

    this->latency = this->get_js_config()->get_child_int("latency");
    this->row_count = this->get_js_config()->get_child_int("row_count");
    this->col_count = this->get_js_config()->get_child_int("col_count");

    this->traces.new_trace("trace", &this->trace);

    this->new_master_port("set", &this->set_itf);
}

vp::IoReqStatus AcaModule::handle_req(vp::Block *__this, vp::IoReq *req)
{
    AcaModule *_this = (AcaModule *)__this;

    _this->trace.msg(vp::TraceLevel::DEBUG, "Received request at offset 0x%lx, size 0x%lx, is_write %d\n",
        req->get_addr(), req->get_size(), req->get_is_write());
    if (req->get_size() == 4)
    {
        if(req->get_addr() == 0   ){
            if(req->get_is_write()){
                _this->row_start = *req->get_data();
                _this->trace.msg(vp::TraceLevel::DEBUG, "Row Start  = %d\n", _this->row_start);
            }
            else{
                *(uint32_t *)req->get_data() = _this->row_start;
            }
        }
        if(req->get_addr() == 0x4){
            if(req->get_is_write()){
                _this->row_stride = *req->get_data();
                _this->trace.msg(vp::TraceLevel::DEBUG, "Row Stride = %d\n", _this->row_stride);
            }
            else{
                *(uint32_t *)req->get_data() = _this->row_stride;
            }
        }
        if(req->get_addr() == 0x8){
            if(req->get_is_write()){
                _this->row_cycles = *req->get_data();
                _this->trace.msg(vp::TraceLevel::DEBUG, "Row Cycles = %d\n", _this->row_cycles);
            }
            else{
                *(uint32_t *)req->get_data() = _this->row_cycles;
            }
        }
        if(req->get_addr() == 0xc){
            if(req->get_is_write()){
                _this->col_start = *req->get_data();
                _this->trace.msg(vp::TraceLevel::DEBUG, "Col Start  = %d\n", _this->col_start);
            }
            else{
                *(uint32_t *)req->get_data() = _this->col_start;
            }
        }
        if(req->get_addr() == 0x10){
            if(req->get_is_write()){
                _this->col_stride = *req->get_data();
                _this->trace.msg(vp::TraceLevel::DEBUG, "Col Stride = %d\n", _this->col_stride);
            }
            else{
                *(uint32_t *)req->get_data() = _this->col_stride;
            }
        }
        if(req->get_addr() == 0x14){
            if(req->get_is_write()){
                _this->col_cycles = *req->get_data();
                _this->trace.msg(vp::TraceLevel::DEBUG, "Col Cycles = %d\n", _this->col_cycles);
                _this->read_scratchpad();
            }
            else{
                *(uint32_t *)req->get_data() = _this->col_cycles;
            }
        }
    }
    return vp::IO_REQ_OK;
}

void AcaModule::handle_event(vp::Block *__this, vp::ClockEvent *event)
{
    AcaModule *_this = (AcaModule *)__this;
    std::tuple<int, int> read_req;
    read_req = _this->queue.front();
    _this->queue.pop();
    _this->trace.msg(vp::TraceLevel::DEBUG, "reading a value from scratchpad: row_idx = %d, col_idx = %d\n", std::get<0>(read_req), std::get<1>(read_req));
    int value = std::get<0>(read_req)*_this->col_count + std::get<1>(read_req);
    _this->set_itf.sync((uint32_t)value);
    if(!_this->queue.empty()) _this->event.enqueue(_this->latency);
}

void AcaModule::read_scratchpad(){
    for(int i = 0; i < this->row_cycles; i++){
        for(int j = 0; j < this->col_cycles; j++){
            int row_idx = this->row_start + this->row_stride*i;
            int col_idx = this->col_start + this->col_stride*j;
            std::tuple<int, int> read_req;
            read_req = std::make_tuple(row_idx, col_idx);
            this->queue.push(read_req);
        }
    }
    this->event.enqueue(this->latency);
}

extern "C" vp::Component *gv_new(vp::ComponentConf &config)
{
    return new AcaModule(config);
}