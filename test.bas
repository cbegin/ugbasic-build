greeting$ = "Hello"

PROCEDURE hello[name$]
    a = a + 1
    PRINT STR$(a) + " " + greeting$ + " " + name$
    RETURN a
END PROC

n = hello["Alice"]
n = hello["Bob"]
n = hello["Charlie"]
PRINT n