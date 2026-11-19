// x0=value -> x0=-1/0/1 for negative/zero/positive.
.text
.global classify_value
.type classify_value, %function
classify_value:
    cmp x0, #0

    // if is less than 0, value is negative, so go to the negative block
    b.lt negative

    // if is more than 0, value is positive, so go to the positve block
    b.gt positive

    // if it is 0, return.
    mov x0, #0
    ret

negative:
    mov x0, #-1
    ret

positive:
    mov x0, #1
    ret

.size classify_value, .-classify_value
.section .note.GNU-stack,"",@progbits
