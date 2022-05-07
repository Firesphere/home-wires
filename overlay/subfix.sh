#!/bin/bash

srts=$(find . -name "*.srt")

for srt in $srts
do
  echo "Fixing up $srt"
  # nbsp thing, needs manual pasting every time
  $(sed -i 's/ / /g' $srt)
  # # Special characters don't work on subtitles
  i=0
  find="’‘ÁáÀàÂâǍǎĂăÃãẢảẠạÄäÅåĀāĄąẤấẦầẪẫẨẩẬậẮắẰằẴẵẲẳẶặǺǻĆćĈĉČčĊċÇçĎďĐđÐÉéÈèÊêĚěĔĕẼẽẺẻĖėËëĒēĘęẾếỀềỄễỂểẸẹỆệĞğĜĝĠġĢģĤĥĦħÍíÌìĬĭÎîǏǐÏïĨĩĮįĪīỈỉỊịĴĵĶķĹĺĽľĻļŁłĿŀŃńŇňÑñŅņÓóÒòŎŏÔôỐốỒồỖỗỔổǑǒÖöŐőÕõØøǾǿŌōỎỏƠơỚớỜờỠỡỞởỢợỌọỘộṔṕṖṗŔŕŘřŖŗŚśŜŝŠšŞşŤťŢţŦŧÚúÙùŬŭÛûǓǔŮůÜüǗǘǛǜǙǚǕǖŰűŨũŲųŪūỦủƯưỨứỪừỮữỬửỰựỤụẂẃẀẁŴŵẄẅÝýỲỳŶŷŸÿỸỹỶỷỴỵŹźŽžŻż"
  replace="''AaAaAaAaAaAaAaAaAaAaAaAaAaAaAaAaAaAaAaAaAaAaAaCcCcCcCcCcDdDdDEeEeEeEeEeEeEeEeEeEeEeEeEeEeEeEeEeGgGgGgGgHhHhIiIiIiIiIiIiIiIiIiIiIiJjKkLlLlLlLlLlNnNnNnNnOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoOoPpPpRrRrRrSsSsSsSsTtTtTtUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuUuWwWwWwWwYyYyYyYyYyYyYyZzZzZz"
  for (( i=0; i<${#find}; i++ )); do
    $(sed -i "s|${find:$i:1}|${replace:$i:1}|g" "$srt")
  done
done

