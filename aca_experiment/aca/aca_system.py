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
import aca_register
from interco.bus_watchpoint import Bus_watchpoint
from elftools.elf.elffile import *


GAPY_TARGET = True

class Soc(gvsoc.systree.Component):

    def __init__(self, parent, name, parser):
        super().__init__(parent, name)

        # Parse the arguments to get the path to the binary to be loaded
        [args, __] = parser.parse_known_args()

        binary = args.binary

        # Main interconnect
        ico = interco.router.Router(self, 'ico')

        aca = aca_module.AcaModule(self, 'aca_module', latency=0x00000001, row_count=256, col_count=256)
        #ico.o_MAP(aca.i_INPUT(), 'aca_module', base=0x20000000, size=0x00001000, rm_base=True)
        ico.add_mapping('aca_module', base=0x20000000, remove_offset=0x20000000, size=0x00001000)
        self.bind(ico, 'aca_module', aca, 'input')

        aca_reg = aca_register.AcaRegister(self, 'aca_register', latency=0x00000001)
        #ico.o_MAP(aca_reg.i_INPUT(), 'aca_register', base=0x30000000, size=0x00001000, rm_base=True)
        ico.add_mapping('aca_reg', base=0x30000000, remove_offset=0x30000000, size=0x00001000)
        self.bind(ico, 'aca_reg', aca_reg, 'input')

        #aca.o_SET(aca_reg.i_SET())
        self.bind(aca, 'set', aca_reg, 'set')

        # Main memory
        mem = memory.memory.Memory(self, 'mem', size=0x00100000)
        # The memory needs to be connected with a mpping. The rm_base is used to substract
        # the global address to the requests address so that the memory only gets a local offset.
        
        #ico.o_MAP(mem.i_INPUT(), 'mem', base=0x00000000, size=0x00100000, rm_base=True)
        ico.add_mapping('mem', base=0x00000000, remove_offset=0x00000000, size=0x00100000)
        self.bind(ico, 'mem', mem, 'input')

        # Instantiates the main core and connect fetch and data to the interconnect
        
        host = pulp.snitch.snitch_core.Spatz(self, 'host', isa='rv32imafdcv')
        #host = cpu.iss.riscv.Riscv(self, 'host', isa='rv64imafdc')
        # host = cpu.iss.iss.Iss(self, 'host',  vp_component='pulp.cpu.iss.iss_snitch_64', isa='rv64imfdvc')
        
        # RISCV bus watchpoint
        tohost_addr = 0
        fromhost_addr = 0
        entry = 0
        if binary is not None:
            with open(binary, 'rb') as file:
                elffile = ELFFile(file)
                entry = elffile['e_entry']
                for section in elffile.iter_sections():
                    if isinstance(section, SymbolTableSection):
                        for symbol in section.iter_symbols():
                            if symbol.name == 'tohost':
                                tohost_addr = symbol.entry['st_value']
                            if symbol.name == 'fromhost':
                                fromhost_addr = symbol.entry['st_value']

        tohost = Bus_watchpoint(self, 'tohost', tohost_addr, fromhost_addr, word_size=32)

        # host.o_FETCH     ( ico.i_INPUT     ())
        # host.o_DATA      ( ico.i_INPUT     ())
        self.bind(host, 'fetch', ico, 'input')
        #self.bind(host, 'data', ico, 'input')
        self.bind(host, 'data', tohost, 'input')


        # Finally connect an ELF loader, which will execute first and will then
        # send to the core the boot address and notify him he can start
        loader = utils.loader.loader.ElfLoader(self, 'loader', binary=binary)
       
        # loader.o_OUT     ( ico.i_INPUT     ())

        # loader.o_START   ( host.i_FETCHEN  ())
        # loader.o_ENTRY   ( host.i_ENTRY    ())
        self.bind(loader, 'out', ico, 'input')
        self.bind(loader, 'start', host, 'fetchen')
        self.bind(loader, 'entry', host, 'bootaddr')

        
        self.bind(host, 'vlsu_0', tohost, 'input')
        self.bind(host, 'vlsu_1', tohost, 'input')
        self.bind(host, 'vlsu_2', tohost, 'input')
        self.bind(host, 'vlsu_3', tohost, 'input')
        self.bind(tohost, 'output', ico, 'input')



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

