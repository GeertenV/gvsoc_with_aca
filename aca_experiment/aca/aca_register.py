import gvsoc.systree

class AcaRegister(gvsoc.systree.Component):

    def __init__(self, parent: gvsoc.systree.Component, name: str, latency: int, vlen: int):
        super().__init__(parent, name)

        self.add_sources(['aca_register.cpp'])

        self.add_properties({
            "latency": latency,
            "vlen": vlen
        })

    def i_INPUT(self) -> gvsoc.systree.SlaveItf:
        return gvsoc.systree.SlaveItf(self, 'input', signature='io')
    
    def i_SET(self) -> gvsoc.systree.SlaveItf:
        return gvsoc.systree.SlaveItf(self, 'set', signature='wire<int,int>')