import gvsoc.systree

class AcaModule(gvsoc.systree.Component):

    def __init__(self, parent: gvsoc.systree.Component, name: str, row_latency: int, col_latency: int, rows: int, cols: int, vlen: int):
        super().__init__(parent, name)

        self.add_sources(['aca_module.cpp'])

        self.add_properties({
            "row_latency": row_latency,
            "col_latency": col_latency,
            "rows": rows,
            "cols": cols,
            "vlen": vlen
        })

    def i_INPUT(self) -> gvsoc.systree.SlaveItf:
        return gvsoc.systree.SlaveItf(self, 'input', signature='io')
    
    def o_SET(self, itf: gvsoc.systree.SlaveItf):
        return self.itf_bind('set', itf, signature='wire<int,int>')