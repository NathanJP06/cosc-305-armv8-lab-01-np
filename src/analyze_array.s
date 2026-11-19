// x0=array, x1=length, x2=48-byte results; calls both helpers for each element.
.text
.global analyze_array
.type analyze_array, %function
analyze_array:
    stp x19, x20, [sp, #-48]!
    stp x21, x22, [sp, #16]
    str x30, [sp, #32]

    mov x19, x0
    mov x20, x1
    mov x21, x2

    str xzr, [x21]
    str xzr, [x21, #8]
    str xzr, [x21, #16]
    str xzr, [x21, #24]
    str xzr, [x21, #32]
    str xzr, [x21, #40]

    cmp x20, #0
    b.eq .Ldone

    ldr x22, [x19]
    str x22, [x21]
    str x22, [x21, #8]

.Lloop:
    ldr x22, [x19], #8

    mov x0, x22
    mov x1, x21
    bl update_min_max

    mov x0, x22
    bl classify_value

    ldr x3, [x21, #16]
    add x3, x3, x22
    str x3, [x21, #16]

    cmp x0, #0
    b.lt .Lnegative
    b.gt .Lpositive
    ldr x3, [x21, #40]
    add x3, x3, #1
    str x3, [x21, #40]
    b .Lnext

.Lpositive:
    ldr x3, [x21, #24]
    add x3, x3, #1
    str x3, [x21, #24]
    b .Lnext

.Lnegative:
    ldr x3, [x21, #32]
    add x3, x3, #1
    str x3, [x21, #32]

.Lnext:
    subs x20, x20, #1
    b.ne .Lloop

.Ldone:
    ldr x30, [sp, #32]
    ldp x21, x22, [sp, #16]
    ldp x19, x20, [sp], #48
    ret
.size analyze_array, .-analyze_array
.section .note.GNU-stack,"",@progbits
