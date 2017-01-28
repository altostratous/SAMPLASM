stacks      segment                                   
    stack       dw      400     dup     (?)
    top         dw      0       dup     (?)
stacks      ends
datas       segment
    length      dw      ?
    arr_start   dw      ?
    arr_end     dw      ?
    off_ret     dw      ?
    array       dw      5, 4, 6, 7, 2
    n           dw      5  
datas       ends
codes       segment
    assume      cs:codes, ds:datas, ss:stacks, es:datas
    qsort       proc    near
        pop     bp
        pop     arr_end
        pop     arr_start
        pushf   
        push    ax
        push    bx
        push    cx
        push    dx
        push    bp
        mov     di, arr_end
        sub     di, 2  
        mov     si, arr_start
        cmp     si, di
        jnl     lout
        mov     ax, word ptr [si]
        mov     cx, arr_end
        sub     cx, arr_start
        mov     length, cx
        xor     cx, cx
        xor     bx, bx
next:   cmp     ax, word ptr [si + bx]
        jle     skip
        add     cx, 2
skip:   add     bx, 2
        cmp     bx, length
        jne     next 
        mov     bx, arr_start
        add     bx, cx
        mov     dx, ax
        xchg    dx, word ptr [bx]
        xchg    dx, word ptr [si]    
nextsi: cmp     si, bx
        jnl     lret
        cmp     ax, word ptr [si]
        jle     nextdi
        add     si, 2
        jmp     nextsi
nextdi: cmp     ax, word ptr [di]
        jg      break 
        sub     di, 2
        ;cmp     si, di
        ;jnl     lret
        jmp     nextdi
break:  ;cmp     si, di
        ;jnl     lret
        mov     dx, word ptr [si]
        xchg    dx, word ptr [di]
        xchg    dx, word ptr [si] 
        jmp     nextsi
;lret1:  add     si, 2
lret:   push    arr_start
        push    bx
        add     bx, 2
        push    bx
        push    arr_end
        call    qsort
        call    qsort
lout:   pop     bp
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        popf    
        push    bp
        ret
    endp
    start:  
        mov     ax, stacks
        mov     ss, ax
        mov     ax, datas
        mov     ds, ax
        mov     es, ax  
        mov     ax, top
        mov     sp, ax
        lea     ax, array 
        push    ax
        add     ax, n
        add     ax, n
        push    ax   
        call    qsort
        retf
codes       ends            
end start