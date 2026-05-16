# 05 Timer – FSM Design (Basys 3)

## Button Mapping

| Button | Function |
|--------|----------|
| btnC   | Reset (global) |
| btnR   | Forward / Confirm / Start / Resume |
| btnL   | Back / Pause |
| btnU   | Increment value |
| btnD   | Decrement value |

---

## State Transitions

### IDLE
- `btnR` → `SET_MODE`

---

### SET_MODE
- `btnR` → `SET_MINUTES`
- `btnL` → `IDLE`

---

### SET_MINUTES
- `btnU` → minutes + 1
- `btnD` → minutes - 1
- `btnR` → `SET_SECONDS`
- `btnL` → `SET_MODE`

---

### SET_SECONDS
- `btnU` → seconds + 1
- `btnD` → seconds - 1
- `btnR` → `RUN`
- `btnL` → `SET_MINUTES`

---

### RUN
- Countdown is active
- `btnL` → `PAUSE`
- If time == `00:00` → `DONE`

---

### PAUSE
- `btnR` → `RUN`
- `btnL` → `SET_SECONDS`

---

### DONE
- `btnR` → `SET_MINUTES`
- `btnL` → `IDLE`

---

## Global Transition

### ANY STATE
- `btnC` → `IDLE`
- Reset minutes = 0, seconds = 0

---

## Summary

- `btnC` = Reset
- `btnR` = Next / Start / Resume
- `btnL` = Back / Pause
- `btnU` = Increase value
- `btnD` = Decrease value