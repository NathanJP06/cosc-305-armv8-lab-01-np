// x0=array, x1=length, x2=48-byte results; calls both helpers for each element.
.text
.global analyze_array
.type analyze_array, %function
analyze_array:
    // Saves registers
    stp x19, x20, [sp, #-48]!
    stp x21, x22, [sp, #16]
    str x30, [sp, #32]

    // Stores array, length, and output address
    mov x19, x0
    mov x20, x1
    mov x21, x2

    // Zeros the result stack
    str xzr, [x21]
    str xzr, [x21, #8]
    str xzr, [x21, #16]
    str xzr, [x21, #24]
    str xzr, [x21, #32]
    str xzr, [x21, #40]

    // Exits if array contains no elements
    cmp x20, #0
    b.eq .Ldone

    // Sets min and max values to the first value.
    ldr x22, [x19]
    str x22, [x21]
    str x22, [x21, #8]

.Lloop:
    // Get next value and move pointer 8 bytes.
    ldr x22, [x19], #8

    // Update min and max for this value
    mov x0, x22
    mov x1, x21
    bl update_min_max

    // Calls classify_value to determine if postitive (+1), negative (-1) or zero (0)
    mov x0, x22
    bl classify_value

    // Add it to the running sum.
    ldr x3, [x21, #16]
    add x3, x3, x22
    str x3, [x21, #16]

    // Choose which count to increment based on the category.
    cmp x0, #0
    b.lt .Lnegative
    b.gt .Lpositive
    // Neither branch matched, so this value is zero.
    ldr x3, [x21, #40]
    add x3, x3, #1
    str x3, [x21, #40]
    b .Lnext

.Lpositive:
    // Jumps to 24, where positive count is
    ldr x3, [x21, #24]
    add x3, x3, #1
    str x3, [x21, #24]
    b .Lnext

.Lnegative:
    // Jumps to 32, where negative count is
    ldr x3, [x21, #32]
    add x3, x3, #1
    str x3, [x21, #32]

.Lnext:
    // Move on to the next value unless that was the last one.
    subs x20, x20, #1
    b.ne .Lloop

.Ldone:
    // Put the saved registers back before returning to the caller.
    ldr x30, [sp, #32]
    ldp x21, x22, [sp, #16]
    ldp x19, x20, [sp], #48
    ret
.size analyze_array, .-analyze_array
.section .note.GNU-stack,"",@progbits
