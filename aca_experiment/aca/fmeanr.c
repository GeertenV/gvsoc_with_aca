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

int main()
{
    int img_height = 3;
    int img_width = 3;
    int r = 1;
    float (*input)[img_width]  = 0x20000000;
    float (*output)[img_width]  = 0x30000000;
    asm("#fmeanr-begin");
    fmeanr(img_height, img_width, r, input, output);
    asm("#fmeanr-end");
    return 0;
}