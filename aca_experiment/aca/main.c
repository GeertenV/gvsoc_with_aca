#include <stdint.h>

int main()
{
    *(uint32_t *)0x20000000 = 0x00000001;
    *(uint32_t *)0x20000004 = 0x00000002;
    *(uint32_t *)0x20000008 = 0x00000003;
    *(uint32_t *)0x2000000c = 0x00000004;
    *(uint32_t *)0x20000010 = 0x00000005;
    *(uint32_t *)0x20000014 = 0x00000006;

    *(volatile uint32_t *)0x30000000;
    *(volatile uint32_t *)0x30000000;
    *(volatile uint32_t *)0x30000000;
    *(volatile uint32_t *)0x30000000;

    *(volatile uint32_t *)0x30000000;
    *(volatile uint32_t *)0x30000000;
    *(volatile uint32_t *)0x30000000;
    *(volatile uint32_t *)0x30000000;

    *(volatile uint32_t *)0x30000000;
    *(volatile uint32_t *)0x30000000;
    *(volatile uint32_t *)0x30000000;
    *(volatile uint32_t *)0x30000000;
    
    *(volatile uint32_t *)0x30000000;
    *(volatile uint32_t *)0x30000000;
    *(volatile uint32_t *)0x30000000;
    *(volatile uint32_t *)0x30000000;

    *(volatile uint32_t *)0x30000000;
    *(volatile uint32_t *)0x30000000;

    // int cycles = 10000000;
    // int henk = 0;
    // while (cycles > 0)
    // {
    //     cycles -= 1;
    //     henk += cycles%57;
    //     henk = henk%123;
    // }

    // printf("%d\n", henk);

    return 0;
}
