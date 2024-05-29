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
    void initialize_array_data();

    vp::IoSlave input_itf;
    vp::ClockEvent event;
    vp::Trace trace;
    vp::WireMaster<std::tuple<int, int>> set_itf;

    uint32_t row_latency;
    uint32_t col_latency;

    int rows;
    int cols;
    int vlen;

    uint8_t row_start;
    uint8_t row_stride;
    uint8_t row_cycles;
    uint8_t col_start;
    uint8_t col_stride;
    uint8_t col_cycles;

    int vec_index = 0;
    int row_cycle_count = 0;
    int col_cycle_count = 0;
    int row_shift_reg = 0;
    int col_shift_reg = 0;

    float** array_data;
};

AcaModule::AcaModule(vp::ComponentConf &config)
    : vp::Component(config), event(this, AcaModule::handle_event)
{
    this->input_itf.set_req_meth(&AcaModule::handle_req);
    this->new_slave_port("input", &this->input_itf);

    this->row_latency = this->get_js_config()->get_child_int("row_latency");
    this->col_latency = this->get_js_config()->get_child_int("col_latency");
    this->rows = this->get_js_config()->get_child_int("rows");
    this->cols = this->get_js_config()->get_child_int("cols");
    this->vlen = this->get_js_config()->get_child_int("vlen");

    this->traces.new_trace("trace", &this->trace);

    this->new_master_port("set", &this->set_itf);

    this->initialize_array_data();
}

void AcaModule::initialize_array_data(){
    this->array_data = new float* [this->rows];
    for (int i = 0; i < this->rows; i++) {
        this->array_data[i] = new float[this->cols];
        for (int j = 0; j < this->cols; j++) {
            array_data[i][j] = (float)(i*this->cols + j);
        }
    }
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
            }
            else{
                *(uint32_t *)req->get_data() = _this->col_cycles;
            }
        }
        if(req->get_addr() == 0x18){
            if(req->get_is_write()){
                _this->trace.msg(vp::TraceLevel::DEBUG, "ACA operation is started.\n");
                _this->read_scratchpad();
            }
        }
    }
    return vp::IO_REQ_OK;
}

void AcaModule::handle_event(vp::Block *__this, vp::ClockEvent *event)
{
    AcaModule *_this = (AcaModule *)__this;

    int row_idx = _this->row_shift_reg;
    int col_idx = _this->col_shift_reg;
    _this->trace.msg(vp::TraceLevel::DEBUG, "reading a value from scratchpad: row_idx = %d, col_idx = %d\n",row_idx, col_idx);

    _this->set_itf.sync(std::make_tuple(_this->vec_index,_this->array_data[row_idx][col_idx]));

    _this->vec_index++;
    if(_this->vec_index==_this->vlen)_this->vec_index = 0;

    _this->col_cycle_count++;
    if(_this->col_cycle_count<_this->col_cycles){
        //not at last column
        _this->col_shift_reg += _this->col_stride;
        _this->event.enqueue(_this->col_latency);
    } else {
        //at last column
        _this->row_cycle_count++;
        _this->col_cycle_count = 0;
        _this->col_shift_reg = _this->col_start;
        if(_this->row_cycle_count<_this->row_cycles) {
            //not at last row
            _this->row_shift_reg += _this->row_stride;
            _this->event.enqueue(_this->row_latency);
        } else {
            //at last row and done
            _this->row_cycle_count = 0;
            _this->row_shift_reg = _this->col_start;
        }
    }
}

void AcaModule::read_scratchpad(){
    this->row_shift_reg = this->row_start;
    this->col_shift_reg = this->col_start;
    this->event.enqueue(this->row_latency);
}

extern "C" vp::Component *gv_new(vp::ComponentConf &config)
{
    return new AcaModule(config);
}