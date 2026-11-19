// x0=value, x1=results pointer; update only fields at offsets 0 and 8.
.text
.global update_min_max
.type update_min_max, %function

update_min_max:
    // Replace the minimum if x0 is smaller.
    ldr x2, [x1]
    cmp x0, x2

    // if value is greater, go check maximum.
    b.ge check_max
    str x0, [x1]

check_max:
    // Check the maximum independently
    ldr x2, [x1, #8]
    cmp x0, x2
    b.le done
    str x0, [x1, #8]

done:
    ret

.size update_min_max, .-update_min_max
.section .note.GNU-stack,"",@progbits
