bigaddseg   segment
    bigadd      proc    far
        ; save return info and parameters
        skip:   pop     off_ret
                pop     seg_ret
                pop     length
                pop     res3ref
                pop     num2ref
                pop     num1ref
                ; save registers
                push    ax
                push    bx
                push    cx
                push    dx
                push    si
                push    di
                push    bp
                push    sp
                pushf
                ; body
                mov     si, num1ref
                mov     di, num2ref
                mov     bx, res3ref
                mov     cx, length
                clc
        next:   mov     ax, word ptr [si]
                adc     ax, word ptr [di]
                mov     word ptr [bx], ax
                inc     di
                inc     si
                inc     bx
                inc     di
                inc     si
                inc     bx
                loop    next
                ; reset registers
                popf    
                pop     sp
                pop     bp
                pop     di
                pop     si
                pop     dx
                pop     cx
                pop     bx
                pop     ax
                ; reset return info
                push    seg_ret
                push    off_ret
                ; return 
                ret
    endp
ends
stacks  segment
    stack:      dw      1000    dup(?)
    top:        dw      0       dup(?)
ends
codes   segment                              
    assume      cs:codes, ss:stacks, ds:codes
    off_bigadd  dw      ?
    seg_bigadd  dw      ?            
    z           dw      2   dup (?)
    n           dw      2
    x           dw      0xF000h
                dw      0x0000h
    y           dw      0x1000h
                dw      0x0000h
        ; parameters and return info        
    off_ret     dw      ?
    seg_ret     dw      ?
    num1ref     dw      ?
    num2ref     dw      ?
    res3ref     dw      ?
    length      dw      ?
    main:       mov     ax, top
                mov     ss, ax 
                mov     ax, cs
                mov     ds, ax
                lea     ax, x
                push    ax
                lea     ax, y
                push    ax
                lea     ax, z
                push    ax
                mov     ax, n
                push    ax
                mov     off_bigadd, bigadd
                mov     seg_bigadd, seg bigadd
                call    far off_bigadd
                retf
ends
end main