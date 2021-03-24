SELECT product.pid, pnm, :cid,  NVL(day, 0)  DAY, NVL(cnt, 0) CNT,cnm
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cycle.cid = :cid)
    JOIN customer ON (:cid = customer.cid);