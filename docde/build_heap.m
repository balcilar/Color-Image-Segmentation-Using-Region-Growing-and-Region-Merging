function [hp, hpind] = build_heap(x,sq)
l = length(x);
hp = x;
hpind = sq;


for i = 2:l
    curnode = i;
    while (curnode>1)
        parnode = fix(curnode/2);
        if hp(parnode)>hp(curnode)%FOR MIN-hp
            %swap value
            tmp = hp(parnode);
            hp(parnode) = hp(curnode);
            hp(curnode) = tmp;
            %swap hpind
            tmp = hpind(parnode);
            hpind(parnode) = hpind(curnode);
            hpind(curnode) = tmp;
            curnode = parnode;
        else
            break;
        end
    end
end



