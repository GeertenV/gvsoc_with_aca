#include <vp/vp.hpp>
#include <vp/itf/io.hpp>

class AcaRegister : public vp::Component
{

public:
    AcaRegister(vp::ComponentConf &config);

private:
    static vp::IoReqStatus handle_req(vp::Block *__this, vp::IoReq *req);
    static void handle_set(vp::Block *__this, int value);
    vp::WireSlave<int> set_itf;
    vp::IoSlave input_itf;
    vp::Trace trace;
    uint32_t latency;
    uint32_t value;
};

AcaRegister::AcaRegister(vp::ComponentConf &config)
    : vp::Component(config)
{
    this->input_itf.set_req_meth(&AcaRegister::handle_req);
    this->new_slave_port("input", &this->input_itf);

    this->set_itf.set_sync_meth(&AcaRegister::handle_set);
    this->new_slave_port("set", &this->set_itf);

    this->latency = this->get_js_config()->get_child_int("latency");
    this->traces.new_trace("trace", &this->trace);
    this->value = 0;
}

void AcaRegister::handle_set(vp::Block *__this, int value)
{
    AcaRegister *_this = (AcaRegister *)__this;

    _this->trace.msg(vp::TraceLevel::DEBUG, "Received value %d\n", value);

    _this->value = value;
}

vp::IoReqStatus AcaRegister::handle_req(vp::Block *__this, vp::IoReq *req)
{
    AcaRegister *_this = (AcaRegister *)__this;

    if (!req->get_is_write() && req->get_size() == 4)
    {
        _this->trace.msg(vp::TraceLevel::DEBUG, "returning value: %d\n", _this->value);
        *(uint32_t *)req->get_data() = _this->value;
        req->inc_latency(_this->latency);
    }
    return vp::IO_REQ_OK;
}

extern "C" vp::Component *gv_new(vp::ComponentConf &config)
{
    return new AcaRegister(config);
}