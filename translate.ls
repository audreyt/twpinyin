
{ zhuyin-mapping } = require './mapping'
{ pinyin-tone } = require './tone'

pinyin-mapping = {}

for key, value of zhuyin-mapping
  pinyin-mapping[value] = key

is-rhymes = (r) ->
  return true if r is 'a' or r is 'e' or r is 'i' or r is 'o' or r is 'u' or r is 'yu' or r is '-'
  return false

is-consonant = (c) ->
  return true if c.match /[a-z]/ and !is-rhymes c
  return false

decode-zhuyin = (zhuyin) ->  
  result = []
  tmp = ''
  for z, i in zhuyin
    if z is 'ㄧ' or z is 'ㄨ' or z is 'ㄩ'
      tmp = z + zhuyin[i+1]
    if tmp.length is 0 and zhuyin-mapping[z]
      result.push zhuyin-mapping[z]
    else if i is (zhuyin.length)-1 and tmp.length > 0
      if tmp is 'ㄧㄛ' or tmp is 'ㄧㄞ' =>
        result.push zhuyin-mapping[tmp]+zhuyin-mapping[z]
      else => result.push zhuyin-mapping[tmp]

    if i is (zhuyin.length)-1
     switch z
     case '˙' then result.push '0'
     case 'ˊ' then result.push '2'
     case 'ˇ' then result.push '3'
     case 'ˋ' then result.push '4'
     default result.push '1'
  return result

encode-pinyin = (proccess-zhuyin) ->
  [ ...proccess, tone] = proccess-zhuyin
  replaced = ''
  for d, i in proccess
    if is-consonant d.0 and decode-zhuyin.length is 2
      d += 'ih' if d is 'jh' or d is 'ch' or d is 'sh' or d is 'r' or d is 'z' or d is 'c' or d is 's'
    if is-rhymes d.0 and i is 0
      if d.match /^ua/
        d = d.replace 'u', 'w'
      else if d.match /^u/
        d = 'w' + d
      else if d.match /^(i|\-)/
        d = d.replace /(i|\-)/, 'y'

    if is-rhymes d.0 or d.0.match /^(y|w)/
      rhyme = if is-rhymes d.0 => d.0
              else => d.1
      r = pinyin-tone.(rhyme).(tone) 
      d = d.replace rhyme, r
    replaced += d
  return replaced

console.log encode-pinyin decode-zhuyin \ㄧㄚ
console.log encode-pinyin decode-zhuyin \ㄉㄧㄚ
console.log encode-pinyin decode-zhuyin \ㄤˇ
console.log encode-pinyin decode-zhuyin \ㄇㄥˊ
console.log encode-pinyin decode-zhuyin \ㄧㄛ
