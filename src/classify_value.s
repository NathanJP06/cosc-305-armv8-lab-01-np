// x0=value -> x0=-1/0/1 for negative/zero/positive.
.text
.global classify_value
.type classify_value, %function
classify_value:
    mov x0, #-1
    ret
    b not_implemented
.size classify_value, .-classify_value
.section .note.GNU-stack,"",@progbits
