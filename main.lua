local LootSystem = {}

-- Настройка множителей и их базовых весов (чем выше вес, тем выше шанс)
local MULTIPLIERS = {
 { name = "x1",   weight = 7000 }, -- 70%
 { name = "x5",   weight = 2000 }, -- 20%
 { name = "x10",  weight = 700  }, -- 7%
 { name = "x30",  weight = 200  }, -- 2%
 { name = "x50",  weight = 95   }, -- 0.95%
 { name = "x100", weight = 5    }  -- 0.05%
}

-- Функция для получения случайного дропа
function LootSystem.rollDrop(luckLuckFactor)
 local luck = luckLuckFactor or 1 -- Множитель удачи игрока (по умолчанию 1)
 local totalWeight = 0
 local adjustedTable = {}

 -- Перерасчет весов с учетом фактора удачи игрока
 for _, item in ipairs(MULTIPLIERS) do
  local currentWeight = item.weight
  -- Редкие предметы получают прирост от удачи
  if item.name ~= "x1" then
   currentWeight = math.floor(currentWeight * luck)
  end
  
  totalWeight = totalWeight + currentWeight
  table.insert(adjustedTable, { name = item.name, weight = currentWeight })
 end

 -- Генерация случайного числа
 local randomNumber = math.random(1, totalWeight)
 local counter = 0

 -- Определение выпавшего предмета
 for _, item in ipairs(adjustedTable) do
  counter = counter + item.weight
  if randomNumber <= counter then
   return item.name
  end
 end

 return "x1"
end

return LootSystem
