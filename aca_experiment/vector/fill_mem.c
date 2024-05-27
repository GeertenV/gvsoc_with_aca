void fill_memory(int img_height, int img_width, float input[img_height][img_width]){
    for(int y=0;y<img_height;y++){
        for(int x=0;x<img_width;x++){
            input[y][x] = (float)((float)y*img_width)+(float)x;
        }
    }
}

int main()
{
    
    int img_height = 3;
    int img_width = 3;
    float (*input)[img_width]  = 0x00000000;
    float (*output)[img_width]  = 0x10000000;
    fill_memory(img_height, img_width, input);
    return 0;
}