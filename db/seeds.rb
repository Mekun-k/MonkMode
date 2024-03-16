level = 1
thresold = 1

100.times do
  LevelSetting.create(level: level, thresold: thresold)

  level += 1
  thresold += 10
end
