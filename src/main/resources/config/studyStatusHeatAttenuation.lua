local members = redis.call('ZRANGE', KEYS[1], 0, -1, 'WITHSCORES')

for i = 1, #members, 2 do
    local member = members[i]
    local score = tonumber(members[i + 1])

    if score < 20 then
        redis.call('ZREM', KEYS[1], member)
    else
        local newScore = score * 0.5
        redis.call('ZINCRBY', KEYS[1], newScore - score, member)
    end
end

return 1