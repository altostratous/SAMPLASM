assume cs:codes,ds:datas

stacks  segment
    stack       dw  100     dup(?)
stacks  ends

datas   segment
    ; constants
    two         dw  2    
    zero        dw  0
    
    ; det params
    det_ret     dw  ?
    det_size    dw  ?
    det_addr    dw  ?           
    det_stride  dw  ?
    
    ; inv params
    inv_ret     dw  ?
    inv_stride  dw  ?
    inv_size    dw  ?
    inv_src     dw  ?
    inv_dst     dw  ? 
    inv_neg     dw  0

    ; matrix        0,1,2|extention
    matrix0     dw  0,0,1,0,0,1
    matrix1     dw  2,3,6,2,3,6
    matrix2     dw  1,2,9,1,2,9
    matext      dw  0,0,1,0,0,1
                dw  2,3,6,2,3,6
                dw  1,2,9,1,2,9
    
    ; inverse
    matinv0     dw  6   dup(?)
    matinv1     dw  6   dup(?)
    matinv2     dw  6   dup(?)                        
        
datas   ends

codes   segment
            ; initialization
    start:  mov  ax,datas  
            mov  ds,ax
            mov  ax,stacks
            mov  ss,ax
            mov  sp,stack+200 
            lea  ax,matrix0
            push ax
            lea  ax,matinv0
            push ax
            push 3
            push 12
            call inv
            ret
    ; void inv(src,dst,size,stride)
    inv:    proc   near           
            ; labels    
                        pop  inv_ret
                        pop  inv_stride
                        pop  inv_size
                        pop  inv_dst
                        pop  inv_src
                        push inv_ret
                        push ax
                        push bx
                        push cx
                        push dx
                        push si
                        push di
                        push bp
                        push inv_src
                        push inv_size
                        push inv_stride
                        call det
                        mov  dx,ax
                        mov  si,inv_src
                        mov  di,inv_dst
                        add  si,2
                        add  si,inv_stride
                        mov  cx,inv_size
            invout:     push cx
                        mov  cx,inv_size
            invin:      push si
                        mov  ax,inv_size
                        dec  ax
                        push ax
                        push inv_stride
                        call det
                        push  dx
                        push  cx  
                        mov   cx,0
                        mov   bx,dx
                        mov   dx,0
                        cmp   bx,zero
                        jnl   skipneg1
                        neg   bx
                        inc   cx
            skipneg1:   cmp   ax,zero
                        jnl   skipneg2
                        neg   ax
                        inc   cx
            skipneg2:   div   bx
                        cmp   cx,zero
                        je    skipagain
            again:      neg   ax
                        loop  again
            skipagain:  pop   cx
                        pop   dx
                        mov  word ptr[di],ax
                        add  di,2
                        add  si,2
                        loop invin
                        pop  cx
                        add  si,inv_stride
                        add  di,inv_stride
                        sub  si,inv_size
                        sub  di,inv_size
                        sub  si,inv_size
                        sub  di,inv_size
                        loop invout
                        pop  bp 
                        pop  di
                        pop  si
                        pop  dx
                        pop  cx
                        pop  bx
                        pop  ax
                        ret
            endp
    ; int det(addr,size,stride) -> ax
    det:    proc
            ; labels                  
                        pop  det_ret 
                        pop  det_stride
                        pop  det_size
                        pop  det_addr
                        ; preserve env 
                        push det_ret
                        mov  ax,2
                        cmp  ax,det_size 
                        ; recursion base
                        jne  skip
                        push bx
                        push cx
                        push dx
                        mov  bx,det_addr
                        mov  ax,word ptr[bx]
                        add  bx,2
                        add  bx,det_stride
                        mov  dx,word ptr[bx]
                        imul dx
                        mov  cx,ax
                        mov  bx,det_addr    
                        add  bx,2
                        mov  ax,word ptr[bx]
                        add  bx,det_stride
                        sub  bx,2
                        mov  dx,word ptr[bx]
                        imul dx
                        sub  cx,ax
                        mov  ax,cx
                        pop  dx
                        pop  cx
                        pop  bx             
                        ret
            skip:       push bx
                        push cx
                        push dx
                        push si
                        push di
                        mov  si,det_addr
                        mov  di,det_addr
                        mov  cx,det_size
                        dec  cx
                        push cx
                        inc  cx  
                        add  di,det_stride
                        mov  bx,0
                        add  di,2
            nextcol:    mov  dx,word ptr[si]
                        pop  ax
                        push ax
                        push di
                        push ax
                        push det_stride
                        call det
                        imul dx
                        add  bx,ax
                        ; neg  bx
                        add  si,2
                        add  di,2
                        cmp  cx,two
                        jne  notlast
                        pop  ax
                        push ax
                        inc  ax
                        shl  ax,1
                        sub  di,ax
            notlast:    loop nextcol
                        pop  cx
            ;            inc  cx
            ;nextneg:    neg  bx
            ;            loop nextneg
                        mov  ax,bx
                        ; reverse env
                        pop  di
                        pop  si  
                        pop  dx
                        pop  cx
                        pop  bx
                        ret
            endp
codes   ends

end     start