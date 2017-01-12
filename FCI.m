function [qsa_prim] = FCI(qsa, factors, name)
    [sorted_qsa, indices] = sort(qsa);
    sorted_qsa(2:end+1) = sorted_qsa;
    sorted_qsa(1) = 0;
    qsa_prim = 0;
    for i=2:numel(qsa)+1
        qsa_prim = qsa_prim + (sorted_qsa(i) - sorted_qsa(i-1)) * get_factors(factors, indices, i, name);
    end
end

function f = get_factors(factors, indices, i, name)
    a = [];
    for j=i-1:numel(factors), a(end+1) = factors(indices(j)); end
    if(numel(factors) <= numel(a))
        f = 1;
    elseif(numel(indices) == 0)
        f = 0;
    else
        if(strcmp(name, 'mean'))
            f = mean(a);
        elseif(strcmp(name, 'max'))
            f = max(a);
        elseif(strcmp(name, 'k-mean'))
            if(numel(a) == 1), f = a(1);
            else
                ap = sort(a);
                s = sum([1:numel(ap)]) - 1;
                for j=1:numel(ap)
                    ap(j) = (ap(j) * j) / s;
                end
                f = min(sum(ap), 1);
            end
        elseif(strcmp(name, 'const-one'))
            f = 1;
        else
            error('Invalid `name` param.');
        end
    end
end

