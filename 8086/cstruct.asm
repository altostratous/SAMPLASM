datas   segment    
    inst    dw      ?          ; int *p;
            dw      5   dup(?) ; int a[5];
            dw      ?          ; foo *f;
datas   ends

codes   segment
    assume  cs:codes,ds:datas
    start:  mov     ax,datas
            mov     ds,ax
            ; inst.a[3] = *(inst.p);
            mov     bx,inst
            mov     ax,word ptr[bx]
            mov     inst+8,ax
            ; inst.a[2] += 3;
            mov     inst+6,3  
            ; *(inst.p) = inst.f->a[0];
            mov     bx,inst+12
            mov     ax,word ptr[bx+2]
            mov     bx,inst
            mov     word ptr[bx],ax 
            ; inst.f->a[2] = inst.a[4];
            mov     ax,inst+10
            mov     bx,inst+12
            mov     word ptr[bx+6],ax
codes   ends     
end     start