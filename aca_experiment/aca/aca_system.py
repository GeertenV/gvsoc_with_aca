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
import aca_module
import output_register
from interco.bus_watchpoint import Bus_watchpoint
from elftools.elf.elffile import *


GAPY_TARGET = True

class Soc(gvsoc.systree.Component):

    def __init__(self, parent, name, parser):
        super().__init__(parent, name)

        [args, __] = parser.parse_known_args()

        binary = args.binary

        ico = interco.router.Router(self, 'ico')#,bandwidth=512, latency=1)

        aca = aca_module.AcaModule(self, 'aca_module', row_latency=2, col_latency=1, rows=256, cols=256, vlen=15)
        ico.add_mapping('aca_module', base=0x2000000, remove_offset=0x2000000, size=0x00001000)
        self.bind(ico, 'aca_module', aca, 'input')

        output_reg = output_register.OutputRegister(self, 'output_register', latency=1, vlen=15)
        ico.add_mapping('output_reg', base=0x3000000, remove_offset=0x3000000, size=0x00001000)
        self.bind(ico, 'output_reg', output_reg, 'input')

        self.bind(aca, 'set', output_reg, 'set')

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

class Rv64(gvsoc.systree.Component):

    def __init__(self, parent, name, parser, options):

        super().__init__(parent, name, options=options)

        clock = vp.clock_domain.Clock_domain(self, 'clock', frequency=100000000)
        soc = Soc(self, 'soc', parser)
        clock.o_CLOCK    ( soc.i_CLOCK     ())

class Target(gvsoc.runner.Target):

    def __init__(self, parser, options):
        super(Target, self).__init__(parser, options,
            model=Rv64, description="RV64 virtual board")

