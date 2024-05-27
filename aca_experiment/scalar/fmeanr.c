#include <stdint.h>

void fmeanr(int img_height, int img_width, int r, float input[img_height][img_width], float output[img_height][img_width]) {
    asm("#before y-loop");
    for(int y=0;y<img_height;y++){
        asm("#before x-loop");
        for(int x=0;x<img_width;x++){
            float sum = 0.0;
            int count = 0;
            asm("#before j-loop");
            for(int j = y-r < 0 ? -y : -r; j <= r && j + y < img_height; j++){
                asm("#before i-loop");
                for(int i = x-r < 0 ? -x : -r; i <= r && i + x < img_width; i++){
                    asm("#inside i-loop");
                    sum += input[y+j][x+i];
                    count++;
                    asm("#inside after i-loop");
                }
                asm("#after i-loop");
            }
            asm("#after j-loop");
            output[y][x] = sum/count;
        }
        asm("#after x-loop");
    }
    asm("#after y-loop");
}

void fill_memory(int img_height, int img_width, float input[img_height][img_width]){
    for(int y=0;y<img_height;y++){
        for(int x=0;x<img_width;x++){
            input[y][x] = (float)((float)y*img_width)+(float)x;
        }
    }
}

int main()
{
    
    int img_height = 5;
    int img_width = 5;
    int r = 2;
    float (*input)[img_width]  = 0x00000000;
    float (*output)[img_width]  = 0x10000000;
    fill_memory(img_height, img_width, input);
    asm("#fmeanr-begin");
    *(volatile uint32_t *)0x20000000 = 0xabbaabba;
    fmeanr(img_height, img_width, r, input, output);
    *(volatile uint32_t *)0x20000000 = 0xdeadcaca;
    asm("#fmeanr-end");
    return 0;
}