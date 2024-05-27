import gvsoc.systree

class BasicScratchpad(gvsoc.systree.Component):

    def __init__(self, parent: gvsoc.systree.Component, name: str, latency: int, row_count: int, col_count: int):
        super().__init__(parent, name)

        self.add_sources(['basic_scratchpad.cpp'])

        self.add_properties({
            "latency": latency,
            "row_count": row_count,
            "col_count": col_count
        })

    def i_INPUT(self) -> gvsoc.systree.SlaveItf:
        return gvsoc.systree.SlaveItf(self, 'input', signature='io')