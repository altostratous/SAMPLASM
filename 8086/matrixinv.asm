assume cs:codes,ds:datas

stacks  segment
    stack       dw  100     dup(?)
stacks  ends

datas   segment
    ; constants
    two         dw  2
    ; det params
    det_ret     dw  ?
    det_size    dw  ?
    det_addr    dw  ?           
    det_stride  dw  ?

    ; matrix
    matrix0     dw  1,2,3,1,2,3
    matrix1     dw  4,5,6,4,5,6
    matrix2     dw  7,8,9,7,8,9
        
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
            push 3
            push 12
            call det
            ret
    ; int det(addr,size,stide)                    
    det:    proc    near
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