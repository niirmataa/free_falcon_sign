x = 2 / 3
print("py-file:", type(x).__name__, "| sage import:", end=" ")
try:
    import sage.all
    print("OK")
except ImportError as e:
    print("NO", e)
