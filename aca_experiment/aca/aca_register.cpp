#include <vp/vp.hpp>
#include <vp/itf/io.hpp>
#include <tuple>

class AcaRegister : public vp::Component
{

public:
    AcaRegister(vp::ComponentConf &config);

private:
    static vp::IoReqStatus handle_req(vp::Block *__this, vp::IoReq *req);
    static void handle_set(vp::Block *__this, std::tuple<int, int> set_input);
    vp::WireSlave<std::tuple<int, int>> set_itf;
    vp::IoSlave input_itf;
    vp::Trace trace;
    uint32_t latency;
    int values[7];
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
    this->values[0] = 0;
    this->values[1] = 0;
    this->values[2] = 0;
    this->values[3] = 0;
    this->values[4] = 0;
    this->values[5] = 0;
    this->values[6] = 0;
}

void AcaRegister::handle_set(vp::Block *__this, std::tuple<int, int> set_input)
{
    AcaRegister *_this = (AcaRegister *)__this;

    //_this->trace.msg(vp::TraceLevel::DEBUG, "Received index %d\n", std::get<0>(set_input));
    //_this->trace.msg(vp::TraceLevel::DEBUG, "Received value %d\n", std::get<1>(set_input));

    _this->values[std::get<0>(set_input)] = std::get<1>(set_input);
}

vp::IoReqStatus AcaRegister::handle_req(vp::Block *__this, vp::IoReq *req)
{
    AcaRegister *_this = (AcaRegister *)__this;

    if (!req->get_is_write() && req->get_size() == 4)
    {

        _this->trace.msg(vp::TraceLevel::DEBUG, "returning value: %d\n", _this->values[req->get_addr()/4]);
        *(float *)req->get_data() = _this->values[req->get_addr()/4];
        req->inc_latency(_this->latency);
    }
    return vp::IO_REQ_OK;
}

extern "C" vp::Component *gv_new(vp::ComponentConf &config)
{
    return new AcaRegister(config);
}