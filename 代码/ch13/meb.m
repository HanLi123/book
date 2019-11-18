function y=meb(x,a,b,c)
if x <= a
    y=0;
end;
if (x > a) && (x <= b)
    y=(x-a)/(b-a);
end;
if (x > b) && (x <= c)
    y=(c-x)/(c-b);
end;
if x > c
    y=0;
end;
if a == b
    if x <= b
        y=1;
    end;
    if (x > b) && (x <= c)
        y=(c-x)/(c-b);
    end;
    if x > c
        y=0;
    end;
end;
if b == c
    if x <= a
        y=0;
    end;
    if (x > a) && (x <= b)
        y=(x-a)/(b-a);
    end;
    if x > b
        y=1;
    end;
end;
