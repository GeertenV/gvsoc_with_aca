#include <vp/vp.hpp>
#include <vp/itf/io.hpp>
#include <queue>
#include <tuple>

class BasicScratchpad : public vp::Component
{

public:
    BasicScratchpad(vp::ComponentConf &config);

private:
    static vp::IoReqStatus handle_req(vp::Block *__this, vp::IoReq *req);
    void read_scratchpad();

    vp::IoSlave input_itf;
    vp::Trace trace;

    uint32_t latency;

    uint32_t row_count;
    uint32_t col_count;

};

BasicScratchpad::BasicScratchpad(vp::ComponentConf &config)
    : vp::Component(config)
{
    this->input_itf.set_req_meth(&BasicScratchpad::handle_req);
    this->new_slave_port("input", &this->input_itf);

    this->latency = this->get_js_config()->get_child_int("latency");
    this->row_count = this->get_js_config()->get_child_int("row_count");
    this->col_count = this->get_js_config()->get_child_int("col_count");

    this->traces.new_trace("trace", &this->trace);
}

vp::IoReqStatus BasicScratchpad::handle_req(vp::Block *__this, vp::IoReq *req)
{
    BasicScratchpad *_this = (BasicScratchpad *)__this;

    _this->trace.msg(vp::TraceLevel::DEBUG, "Received request at offset 0x%lx, is_write %d\n",
        req->get_addr(), req->get_is_write());
        if(req->get_size() == 4){
            if (!req->get_is_write()){
                float return_val = (req->get_addr()/4);//%_this->col_count;
                *(float *)req->get_data() = return_val;
                _this->trace.msg(vp::TraceLevel::DEBUG, "return val  = %.1f\n", return_val);
            }
            else {
                float write_val = *(float *)req->get_data();
                _this->trace.msg(vp::TraceLevel::DEBUG, "write  = %.1f\n", write_val);
            }
        }
        req->inc_latency(_this->latency);
    return vp::IO_REQ_OK;
}


extern "C" vp::Component *gv_new(vp::ComponentConf &config)
{
    return new BasicScratchpad(config);
}