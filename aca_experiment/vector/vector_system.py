import cpu.iss.riscv
import pulp.snitch.snitch_core
from pulp.snitch.snitch_isa import *
from cpu.iss.isa_gen.isa_rvv import *
import memory.memory
import vp.clock_domain
import interco.router
import utils.loader.loader
import gvsoc.systree
import gvsoc.runner
from interco.bus_watchpoint import Bus_watchpoint
from elftools.elf.elffile import *


GAPY_TARGET = True

class Soc(gvsoc.systree.Component):

    def __init__(self, parent, name, parser):
        super().__init__(parent, name)

        [args, __] = parser.parse_known_args()

        binary = args.binary

        ico = interco.router.Router(self, 'ico')

        mem = memory.memory.Memory(self, 'mem', size=0x1000000)

        ico.add_mapping('mem', base=0x00000000, remove_offset=0x00000000, size=0x1000000)
        self.bind(ico, 'mem', mem, 'input')

        
        host = pulp.snitch.snitch_core.Spatz(self, 'host', isa='rv32imfdcv')
        

        self.bind(host, 'fetch', ico, 'input')
        self.bind(host, 'data', ico, 'input')

        loader = utils.loader.loader.ElfLoader(self, 'loader', binary=binary)

        self.bind(loader, 'out', ico, 'input')
        self.bind(loader, 'start', host, 'fetchen')
        self.bind(loader, 'entry', host, 'bootaddr')

        
        self.bind(host, 'vlsu_0', ico, 'input')
        self.bind(host, 'vlsu_1', ico, 'input')
        self.bind(host, 'vlsu_2', ico, 'input')
        self.bind(host, 'vlsu_3', ico, 'input')



# This is a wrapping component of the real one in order to connect a clock generator to it
# so that it automatically propagate to other components
class Rv64(gvsoc.systree.Component):

    def __init__(self, parent, name, parser, options):

        super().__init__(parent, name, options=options)

        clock = vp.clock_domain.Clock_domain(self, 'clock', frequency=100000000)
        soc = Soc(self, 'soc', parser)
        clock.o_CLOCK    ( soc.i_CLOCK     ())




# This is the top target that gapy will instantiate
class Target(gvsoc.runner.Target):

    def __init__(self, parser, options):
        super(Target, self).__init__(parser, options,
            model=Rv64, description="RV64 virtual board")

