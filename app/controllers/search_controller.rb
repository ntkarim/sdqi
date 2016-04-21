class SearchController < ApplicationController
  def index

    @countries = Search.all
    #################################### Begin of Country List Section ###################
    distinctcountry = Search.select("DISTINCT(country)")
    @listcountries = distinctcountry.order('country ASC')

    distinctsubject = Search.select("DISTINCT(subject_descriptor)")
    @listsubjects = distinctsubject.order('subject_descriptor ASC')




      ################################### End of Country List Section ##############################################

    ####################################  Begin of Year list Section #######################
    inityear = 1980
    @years = Array.new
    j = 0
    while inityear < 2021 do
      @years.insert(j,inityear)
      inityear = inityear + 1
      j = j+1
    end

    if params[:amount].nil?
      test = Array.new

    else
      amount = params[:amount]
      test = amount.split(",")
    end

    params[:year1] = test[0]
    params[:year2] = test[1]

    year1 = params[:year1]
    year2 = params[:year2]

    yearcount = year2.to_i - year1.to_i

    @startyear = year1
    @finalyear = year2

    puts year2.to_i - year1.to_i + 1
    year0 = 0
yearquery = ""
    for year0 in 0..yearcount
      currentyear = year1.to_i + year0
      if year0 == 0
        yearquery = yearquery + "(data_" + currentyear.to_s + ")"
      else
        yearquery = yearquery + ","+ "(data_" + currentyear.to_s + ")"
      end

    end
puts yearquery  # year query is a query statement


    @chosenYears = Array.new
    firstYear = params[:year1]
    firstYearinInt = firstYear.to_i
    year0 = 0
    puts "2222222222"
    puts yearcount
    puts year0
    while(year0<=yearcount)
      @chosenYears.insert(year0,firstYearinInt)
      firstYearinInt = firstYearinInt + 1
      puts @chosenYears[year0]
      year0 = year0 + 1

    end
    puts "2222222222"
    ####################################### End of Year list Section ################################################



      #################################### Begin of Query Section ###########################
    if params[:country_list].present?

      key = params[:country_list].values
      values = Array.new
      i = 0
      while i < key.first.size-1
        values.insert(i, key.first[i])
        i = i+1
      end

      #//////////////// Added for multiple subjects ////////////////////////////////
      subjectkey = params[:subject_list].values
      subvalues = Array.new
      i = 0
      while i < subjectkey.first.size-1
        subvalues.insert(i, subjectkey.first[i])
        i = i+1
      end
      puts "subvalue"
      puts subvalues
      #//////////////// Added for multiple subjects ////////////////////////////////


      if params[:subject_list].present?


        @displays = Search.where(:country => values).where(:subject_descriptor => subvalues)



        @displays = @displays.select("(country),(weo_country_code),(units),(iso),(weo_subject_code),"+yearquery)  #Query testing
      #  puts @displaysyears.first
      else


        @displays = Search.where(:country => values)

      end

    else
      @displays = Search.where(:country => "")

    end
    ###################################### End of Query Section ####################################


    ###################################### Begin of Chart Section ###################################
    if params[:subject_list].present?
      @chart = LazyHighCharts::HighChart.new('graph') do |f|
        s = values.map(&:inspect).join(', ')
        e =  subvalues.map(&:inspect).join(', ')
        f.title(text: e + " Statistics For " + s + " from " + params[:year1] + "-" + params[:year2])
        i = 0
        while i < values.length
          subjectindex = 0

          while(subjectindex < subvalues.length)
            @displayByCountry = Search.select(yearquery + ",(scale)").where(:country => values[i]).where(:subject_descriptor => subvalues[subjectindex])
            countryValue = Array.new

            @displayByCountry.each do |request|
              dataforYearChosen = 0
              while(dataforYearChosen < @chosenYears.length)
                String temp = ""
                temp = "data_" + @chosenYears[dataforYearChosen].to_s
                countryValue.push([@chosenYears[dataforYearChosen],request.send(temp.to_sym).to_f])
                dataforYearChosen = dataforYearChosen + 1
              end
            end
            if((subjectindex + 1) % 2 == 0)
              if((i+1) % 2 == 0)
                f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, color: '#191970', marker: { symbol: 'triangle' })
              elsif((i+1) % 3 == 0)
                f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, color: '#8b0000', marker: { symbol: 'triangle' })
              elsif((i+1) % 4 == 0)
                f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, color: '#daa520', marker: { symbol: 'triangle' })
              else
                f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, color: '#7fe2ff', marker: { symbol: 'triangle' })
              end

            elsif((subjectindex + 1) % 3 == 0)
              if((i+1) % 2 == 0)
                f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, color: '#191970', marker: { symbol: 'diamond' })
              elsif((i+1) % 3 == 0)
                f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, color: '#8b0000', marker: { symbol: 'diamond' })
              elsif((i+1) % 4 == 0)
                f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, color: '#daa520', marker: { symbol: 'diamond' })
              else
                f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, color: '#7fe2ff', marker: { symbol: 'diamond' })
              end

            elsif((subjectindex + 1) % 4 == 0)
              if((i+1) % 2 == 0)
                f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, color: '#191970', marker: { symbol: 'square' })
              elsif((i+1) % 3 == 0)
                f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, color: '#8b0000', marker: { symbol: 'square' })
              elsif((i+1) % 4 == 0)
                f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, color: '#daa520', marker: { symbol: 'square' })
              else
                f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, color: '#7fe2ff', marker: { symbol: 'square' })
              end

            else
              if((i+1) % 2 == 0)
                f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, color: '#191970', marker: { symbol: 'circle' })
              elsif((i+1) % 3 == 0)
                f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, color: '#8b0000', marker: { symbol: 'circle' })
              elsif((i+1) % 4 == 0)
                f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, color: '#daa520', marker: { symbol: 'circle' })
              else
                f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, color: '#7fe2ff', marker: { symbol: 'circle' })
              end
            end

            subjectindex = subjectindex + 1
          end

          scaleUnits = ""
          @displayByCountry.each do |request|
            scaleUnits = request.scale
          end

          if(subvalues.length==1)
            if scaleUnits != nil
              f.yAxis [
                          {title: {text: "#{subvalues[0]} in " + scaleUnits, margin: 70}}
                      ]
            else
              f.yAxis [
                          {title: {text: "#{subvalues[0]}", margin: 70}}

                      ]
            end
          elsif (subvalues.length == 2)
            if scaleUnits != nil
              f.yAxis [
                          {title: {text: "#{subvalues[0]} in " + scaleUnits, margin: 70}},
                          {title: {text: "#{subvalues[1]} in " + scaleUnits, margin: 70}, opposite: true}
                      ]
            else
              f.yAxis [
                          {title: {text: "#{subvalues[0]}", margin: 70}},
                          {title: {text: "#{subvalues[1]}", margin: 70}, opposite: true},
                      ]
            end
          elsif (subvalues.length == 3)
            if scaleUnits != nil
              f.yAxis [
                          {title: {text: "#{subvalues[0]} in " + scaleUnits, margin: 70}},
                          {title: {text: "#{subvalues[1]} in " + scaleUnits, margin: 70}, opposite: true},
                          {title: {text: "#{subvalues[2]} in " + scaleUnits, margin: 70}},
                      ]
            else
              f.yAxis [
                          {title: {text: "#{subvalues[0]}", margin: 70}},
                          {title: {text: "#{subvalues[1]}", margin: 70}, opposite: true},
                          {title: {text: "#{subvalues[2]}", margin: 70}},
                      ]
            end
          else
            if scaleUnits != nil
              f.yAxis [
                          {title: {text: "#{subvalues[0]} in " + scaleUnits, margin: 70}},
                          {title: {text: "#{subvalues[1]} in " + scaleUnits, margin: 70}, opposite: true},
                          {title: {text: "#{subvalues[2]} in " + scaleUnits, margin: 70}},
                          {title: {text: "#{subvalues[3]} in " + scaleUnits, margin: 70}, opposite: true},
                      ]
            else
              f.yAxis [
                          {title: {text: "#{subvalues[0]}", margin: 70}},
                          {title: {text: "#{subvalues[1]}", margin: 70}, opposite: true},
                          {title: {text: "#{subvalues[2]}", margin: 70}},
                          {title: {text: "#{subvalues[3]}", margin: 70}, opposite: true},
                      ]
            end
          end

          i = i + 1
        end
        f.plotOptions(
            scatter: {
                marker: {
                    radius: 5,
                    states: {
                        hover: {
                            enabled: true,
                            lineColor: 'rgb(100,100,100)'
                        }
                    }
                },
                tooltip: {
                    headerFormat: '<b>{series.name}</b><br>',
                    pointFormat: "Year- {point.x}, {point.y}"
                }
            }
        )
        f.options[:chart][:width] = 1220
        f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
        f.chart({defaultSeriesType: "scatter"})
      end


      @chart2 = LazyHighCharts::HighChart.new('graph') do |f|
        s = values.map(&:inspect).join(', ')
        e =  subvalues.map(&:inspect).join(', ')
        f.title(text: e + " Statistics For " + s + " from " + params[:year1] + "-" + params[:year2])
        i = 0
        while i < values.length
          subjectindex = 0

          while(subjectindex < subvalues.length)
            @displayByCountry = Search.select(yearquery + ",(scale)").where(:country => values[i]).where(:subject_descriptor => subvalues[subjectindex])
            countryValue = Array.new

            @displayByCountry.each do |request|
              dataforYearChosen = 0
              while(dataforYearChosen < @chosenYears.length)
                String temp = ""
                temp = "data_" + @chosenYears[dataforYearChosen].to_s
                countryValue.push([@chosenYears[dataforYearChosen],request.send(temp.to_sym).to_f])
                dataforYearChosen = dataforYearChosen + 1
              end
            end

            f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue)
            subjectindex = subjectindex + 1
          end

          scaleUnits = ""
          @displayByCountry.each do |request|
            scaleUnits = request.scale
          end

          if(subvalues.length==1)
            if scaleUnits != nil
              f.yAxis [
                          {title: {text: "#{subvalues[0]} in " + scaleUnits, margin: 70}}
                      ]
            else
              f.yAxis [
                          {title: {text: "#{subvalues[0]}", margin: 70}}
                      ]
            end
          elsif (subvalues.length == 2)
            if scaleUnits != nil
              f.yAxis [
                          {title: {text: "#{subvalues[0]} in " + scaleUnits, margin: 70}},
                          {title: {text: "#{subvalues[1]} in " + scaleUnits, margin: 70}, opposite: true}
                      ]
            else
              f.yAxis [
                          {title: {text: "#{subvalues[0]}", margin: 70}},
                          {title: {text: "#{subvalues[1]}", margin: 70}, opposite: true},
                      ]
            end
          else
            if scaleUnits != nil
              f.yAxis [
                          {title: {text: "#{subvalues[0]} in " + scaleUnits, margin: 70}},
                          {title: {text: "#{subvalues[1]} in " + scaleUnits, margin: 70}, opposite: true},
                          {title: {text: "#{subvalues[2]} in " + scaleUnits, margin: 70}},
                      ]
            else
              f.yAxis [
                          {title: {text: "#{subvalues[0]}", margin: 70}},
                          {title: {text: "#{subvalues[1]}", margin: 70}, opposite: true},
                          {title: {text: "#{subvalues[2]}", margin: 70}},
                      ]
            end
          end

          i = i + 1
        end
        f.plotOptions(
            area: {
                stacking: 'normal',
                lineColor: '#666666',
                lineWidth: 1,
                marker: {
                    lineWidth: 1,
                    lineColor: '#666666'
                },
                fillOpacity: 0.5,
                tooltip: {
                    shared: true,
                    headerFormat: '<b>{series.name}</b><br>',
                    pointFormat: "Year- {point.x}, {point.y}"
                }
            }
        )
        f.options[:chart][:width] = 1220
        f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
        f.chart({defaultSeriesType: "area"})
      end

      @chart3 = LazyHighCharts::HighChart.new('graph') do |f|
        s = values.map(&:inspect).join(', ')
        e =  subvalues.map(&:inspect).join(', ')
        f.title(text: e + " Statistics For " + s + " from " + params[:year1] + "-" + params[:year2])
        i = 0
        sum = 0
        summationOfValues = Array.new
        while i < values.length
          subjectindex = 0

          while(subjectindex < subvalues.length)
            @displayByCountry = Search.select(yearquery + ",(scale)").where(:country => values[i]).where(:subject_descriptor => subvalues[subjectindex])
            countryValue = Array.new

            @displayByCountry.each do |request|
              dataforYearChosen = 0
              while(dataforYearChosen < @chosenYears.length)
                String temp = ""
                temp = "data_" + @chosenYears[dataforYearChosen].to_s
                countryValue.push([@chosenYears[dataforYearChosen],request.send(temp.to_sym).to_f])
                if(summationOfValues[sum] == nil)
                  summationOfValues[sum] = 0
                  summationOfValues[sum] = summationOfValues[sum] + request.send(temp.to_sym).to_f
                else
                  summationOfValues[sum] = summationOfValues[sum] + request.send(temp.to_sym).to_f
                end
                dataforYearChosen = dataforYearChosen + 1
              end
            end

            f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, type: 'column', height: 300)
            subjectindex = subjectindex + 1
            sum = sum + 1
          end


          scaleUnits = ""
          @displayByCountry.each do |request|
            scaleUnits = request.scale
          end
          if(subvalues.length==1)
            if scaleUnits != nil
              f.yAxis [
                          {title: {text: "#{subvalues[0]} in " + scaleUnits, margin: 20}}
                      ]
            else
              f.yAxis [
                          {title: {text: "#{subvalues[0]}", margin: 20}}
                      ]
            end
          elsif (subvalues.length == 2)
            if scaleUnits != nil
              f.yAxis [
                          {title: {text: "#{subvalues[0]} in " + scaleUnits, margin: 20}},
                          {title: {text: "#{subvalues[1]} in " + scaleUnits, margin: 20}, opposite: true}
                      ]
            else
              f.yAxis [
                          {title: {text: "#{subvalues[0]}", margin: 20}},
                          {title: {text: "#{subvalues[1]}", margin: 20}, opposite: true},
                      ]
            end
          else
            if scaleUnits != nil
              f.yAxis [
                          {title: {text: "#{subvalues[0]} in " + scaleUnits, margin: 20}},
                          {title: {text: "#{subvalues[1]} in " + scaleUnits, margin: 20}, opposite: true},
                          {title: {text: "#{subvalues[2]} in " + scaleUnits, margin: 20}},
                      ]
            else
              f.yAxis [
                          {title: {text: "#{subvalues[0]}", margin: 20}},
                          {title: {text: "#{subvalues[1]}", margin: 20}, opposite: true},
                          {title: {text: "#{subvalues[2]}", margin: 20}},
                      ]
            end
          end
          i = i + 1
        end
        f.plotOptions(
            line: {
                plotLines: [{
                                width: 1,
                                color: '#808080'
                            }],
                tooltip: {
                    shared: true,
                    headerFormat: '<b>{series.name}</b><br>',
                    pointFormat: "Year- {point.x}, {point.y}"
                }
            }
        )
        f.options[:chart][:width] = 1220
        f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      end



      @chart4 = LazyHighCharts::HighChart.new('graph') do |f|
        i = 0
        sum = 0
        summationOfValues = Array.new
        countryOfValues = Array.new
        while i < values.length
          subjectindex = 0

          while(subjectindex < subvalues.length)
            @displayByCountry = Search.select(yearquery + ",(scale)").where(:country => values[i]).where(:subject_descriptor => subvalues[subjectindex])
            countryValue = Array.new


            @displayByCountry.each do |request|
              dataforYearChosen = 0
              while(dataforYearChosen < @chosenYears.length)
                String temp = ""
                temp = "data_" + @chosenYears[dataforYearChosen].to_s
                countryValue.push([@chosenYears[dataforYearChosen],request.send(temp.to_sym).to_f])
                if(summationOfValues[sum] == nil)
                  summationOfValues[sum] = 0
                  summationOfValues[sum] = summationOfValues[sum] + request.send(temp.to_sym).to_f
                else
                  summationOfValues[sum] = summationOfValues[sum] + request.send(temp.to_sym).to_f
                end
                dataforYearChosen = dataforYearChosen + 1
              end
            end
            countryOfValues.push(values[i],summationOfValues[sum])
            subjectindex = subjectindex + 1
            sum = sum + 1
          end
          i = i + 1
        end



        if(countryOfValues.length == 2)
          f.series(name: "Total Summation",  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}])
        elsif(countryOfValues.length == 4 )
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}])
        elsif (countryOfValues.length == 6)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}])
        elsif (countryOfValues.length == 8)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}])
        elsif (countryOfValues.length == 10)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}, {name: countryOfValues[8], y: countryOfValues[9]}])
        elsif (countryOfValues.length == 12)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}, {name: countryOfValues[8], y: countryOfValues[9]}, {name: countryOfValues[10], y: countryOfValues[11]}])
        elsif (countryOfValues.length == 14)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}, {name: countryOfValues[8], y: countryOfValues[9]}, {name: countryOfValues[10], y: countryOfValues[11]}, {name: countryOfValues[12], y: countryOfValues[13]}])
        elsif (countryOfValues.length == 16)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}, {name: countryOfValues[8], y: countryOfValues[9]}, {name: countryOfValues[10], y: countryOfValues[11]}, {name: countryOfValues[12], y: countryOfValues[13]}, {name: countryOfValues[14], y: countryOfValues[15]}])
        elsif (countryOfValues.length == 18)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}, {name: countryOfValues[8], y: countryOfValues[9]}, {name: countryOfValues[10], y: countryOfValues[11]}, {name: countryOfValues[12], y: countryOfValues[13]}, {name: countryOfValues[14], y: countryOfValues[15]}, {name: countryOfValues[16], y: countryOfValues[17]}])
        elsif (countryOfValues.length == 20)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}, {name: countryOfValues[8], y: countryOfValues[9]}, {name: countryOfValues[10], y: countryOfValues[11]}, {name: countryOfValues[12], y: countryOfValues[13]}, {name: countryOfValues[14], y: countryOfValues[15]}, {name: countryOfValues[16], y: countryOfValues[17]}, {name: countryOfValues[18], y: countryOfValues[19]}])
        elsif (countryOfValues.length == 22)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}, {name: countryOfValues[8], y: countryOfValues[9]}, {name: countryOfValues[10], y: countryOfValues[11]}, {name: countryOfValues[12], y: countryOfValues[13]}, {name: countryOfValues[14], y: countryOfValues[15]}, {name: countryOfValues[16], y: countryOfValues[17]}, {name: countryOfValues[18], y: countryOfValues[19]}, {name: countryOfValues[20], y: countryOfValues[21]}])
        elsif (countryOfValues.length == 24)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}, {name: countryOfValues[8], y: countryOfValues[9]}, {name: countryOfValues[10], y: countryOfValues[11]}, {name: countryOfValues[12], y: countryOfValues[13]}, {name: countryOfValues[14], y: countryOfValues[15]}, {name: countryOfValues[16], y: countryOfValues[17]}, {name: countryOfValues[18], y: countryOfValues[19]}, {name: countryOfValues[20], y: countryOfValues[21]}, {name: countryOfValues[22], y: countryOfValues[23]}])
        elsif (countryOfValues.length == 26)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}, {name: countryOfValues[8], y: countryOfValues[9]}, {name: countryOfValues[10], y: countryOfValues[11]}, {name: countryOfValues[12], y: countryOfValues[13]}, {name: countryOfValues[14], y: countryOfValues[15]}, {name: countryOfValues[16], y: countryOfValues[17]}, {name: countryOfValues[18], y: countryOfValues[19]}, {name: countryOfValues[20], y: countryOfValues[21]}, {name: countryOfValues[22], y: countryOfValues[23]}, {name: countryOfValues[24], y: countryOfValues[25]}])
        elsif (countryOfValues.length == 28)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}, {name: countryOfValues[8], y: countryOfValues[9]}, {name: countryOfValues[10], y: countryOfValues[11]}, {name: countryOfValues[12], y: countryOfValues[13]}, {name: countryOfValues[14], y: countryOfValues[15]}, {name: countryOfValues[16], y: countryOfValues[17]}, {name: countryOfValues[18], y: countryOfValues[19]}, {name: countryOfValues[20], y: countryOfValues[21]}, {name: countryOfValues[22], y: countryOfValues[23]}, {name: countryOfValues[24], y: countryOfValues[25]}, {name: countryOfValues[26], y: countryOfValues[27]}])
        elsif (countryOfValues.length == 30)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}, {name: countryOfValues[8], y: countryOfValues[9]}, {name: countryOfValues[10], y: countryOfValues[11]}, {name: countryOfValues[12], y: countryOfValues[13]}, {name: countryOfValues[14], y: countryOfValues[15]}, {name: countryOfValues[16], y: countryOfValues[17]}, {name: countryOfValues[18], y: countryOfValues[19]}, {name: countryOfValues[20], y: countryOfValues[21]}, {name: countryOfValues[22], y: countryOfValues[23]}, {name: countryOfValues[24], y: countryOfValues[25]}, {name: countryOfValues[26], y: countryOfValues[27]}, {name: countryOfValues[28], y: countryOfValues[29]}])
        elsif (countryOfValues.length == 32)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}, {name: countryOfValues[8], y: countryOfValues[9]}, {name: countryOfValues[10], y: countryOfValues[11]}, {name: countryOfValues[12], y: countryOfValues[13]}, {name: countryOfValues[14], y: countryOfValues[15]}, {name: countryOfValues[16], y: countryOfValues[17]}, {name: countryOfValues[18], y: countryOfValues[19]}, {name: countryOfValues[20], y: countryOfValues[21]}, {name: countryOfValues[22], y: countryOfValues[23]}, {name: countryOfValues[24], y: countryOfValues[25]}, {name: countryOfValues[26], y: countryOfValues[27]}, {name: countryOfValues[28], y: countryOfValues[29]}, {name: countryOfValues[30], y: countryOfValues[31]}])
        elsif (countryOfValues.length == 34)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}, {name: countryOfValues[8], y: countryOfValues[9]}, {name: countryOfValues[10], y: countryOfValues[11]}, {name: countryOfValues[12], y: countryOfValues[13]}, {name: countryOfValues[14], y: countryOfValues[15]}, {name: countryOfValues[16], y: countryOfValues[17]}, {name: countryOfValues[18], y: countryOfValues[19]}, {name: countryOfValues[20], y: countryOfValues[21]}, {name: countryOfValues[22], y: countryOfValues[23]}, {name: countryOfValues[24], y: countryOfValues[25]}, {name: countryOfValues[26], y: countryOfValues[27]}, {name: countryOfValues[28], y: countryOfValues[29]}, {name: countryOfValues[30], y: countryOfValues[31]}, {name: countryOfValues[32], y: countryOfValues[33]}])
        elsif (countryOfValues.length == 36)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}, {name: countryOfValues[8], y: countryOfValues[9]}, {name: countryOfValues[10], y: countryOfValues[11]}, {name: countryOfValues[12], y: countryOfValues[13]}, {name: countryOfValues[14], y: countryOfValues[15]}, {name: countryOfValues[16], y: countryOfValues[17]}, {name: countryOfValues[18], y: countryOfValues[19]}, {name: countryOfValues[20], y: countryOfValues[21]}, {name: countryOfValues[22], y: countryOfValues[23]}, {name: countryOfValues[24], y: countryOfValues[25]}, {name: countryOfValues[26], y: countryOfValues[27]}, {name: countryOfValues[28], y: countryOfValues[29]}, {name: countryOfValues[30], y: countryOfValues[31]}, {name: countryOfValues[32], y: countryOfValues[33]}, {name: countryOfValues[34], y: countryOfValues[35]}])
        elsif (countryOfValues.length == 38)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}, {name: countryOfValues[8], y: countryOfValues[9]}, {name: countryOfValues[10], y: countryOfValues[11]}, {name: countryOfValues[12], y: countryOfValues[13]}, {name: countryOfValues[14], y: countryOfValues[15]}, {name: countryOfValues[16], y: countryOfValues[17]}, {name: countryOfValues[18], y: countryOfValues[19]}, {name: countryOfValues[20], y: countryOfValues[21]}, {name: countryOfValues[22], y: countryOfValues[23]}, {name: countryOfValues[24], y: countryOfValues[25]}, {name: countryOfValues[26], y: countryOfValues[27]}, {name: countryOfValues[28], y: countryOfValues[29]}, {name: countryOfValues[30], y: countryOfValues[31]}, {name: countryOfValues[32], y: countryOfValues[33]}, {name: countryOfValues[34], y: countryOfValues[35]}, {name: countryOfValues[36], y: countryOfValues[37]}])
        elsif (countryOfValues.length == 40)
          f.series(name: "Total Summation", type: 'pie',  size: 200,  center: [300, 150], data: [{name: countryOfValues[0], y: countryOfValues[1]}, {name: countryOfValues[2], y: countryOfValues[3]}, {name: countryOfValues[4], y: countryOfValues[5]}, {name: countryOfValues[6], y: countryOfValues[7]}, {name: countryOfValues[8], y: countryOfValues[9]}, {name: countryOfValues[10], y: countryOfValues[11]}, {name: countryOfValues[12], y: countryOfValues[13]}, {name: countryOfValues[14], y: countryOfValues[15]}, {name: countryOfValues[16], y: countryOfValues[17]}, {name: countryOfValues[18], y: countryOfValues[19]}, {name: countryOfValues[20], y: countryOfValues[21]}, {name: countryOfValues[22], y: countryOfValues[23]}, {name: countryOfValues[24], y: countryOfValues[25]}, {name: countryOfValues[26], y: countryOfValues[27]}, {name: countryOfValues[28], y: countryOfValues[29]}, {name: countryOfValues[30], y: countryOfValues[31]}, {name: countryOfValues[32], y: countryOfValues[33]}, {name: countryOfValues[34], y: countryOfValues[35]}, {name: countryOfValues[36], y: countryOfValues[37]}, {name: countryOfValues[38], y: countryOfValues[39]}])
        end


        f.options[:chart][:width] = 1220
        f.chart({defaultSeriesType: "pie"})
      end
    end
    ########################################## End of Chart Section ########################################
  end


  def table

    @countries = Search.all
    #################################### Begin of Country List Section ###################
    distinctcountry = Search.select("DISTINCT(country)")
    @listcountries = distinctcountry.order('country ASC')

    distinctsubject = Search.select("DISTINCT(subject_descriptor)")
    @listsubjects = distinctsubject.order('subject_descriptor ASC')




    ################################### End of Country List Section ##############################################

    ####################################  Begin of Year list Section #######################
    inityear = 1980
    @years = Array.new
    j = 0
    while inityear < 2021 do
      @years.insert(j,inityear)
      inityear = inityear + 1
      j = j+1
    end

    if params[:amount].nil?
      test = Array.new

    else
      amount = params[:amount]
      test = amount.split(",")
    end

    params[:year1] = test[0]
    params[:year2] = test[1]

    year1 = params[:year1]
    year2 = params[:year2]

    yearcount = year2.to_i - year1.to_i

    @startyear = year1
    @finalyear = year2


    year0 = 0
    yearquery = ""
    for year0 in 0..yearcount
      currentyear = year1.to_i + year0
      if year0 == 0
        yearquery = yearquery + "(data_" + currentyear.to_s + ")"
      else
        yearquery = yearquery + ","+ "(data_" + currentyear.to_s + ")"
      end

    end


    @chosenYears = Array.new
    firstYear = params[:year1]
    firstYearinInt = firstYear.to_i
    year0 = 0

    while(year0<=yearcount)
      @chosenYears.insert(year0,firstYearinInt)
      firstYearinInt = firstYearinInt + 1
      puts @chosenYears[year0]
      year0 = year0 + 1

    end

    ####################################### End of Year list Section ################################################



    #################################### Begin of Query Section ###########################
    if params[:country_list].present?

      key = params[:country_list].values
      values = Array.new
      i = 0
      while i < key.first.size-1
        values.insert(i, key.first[i])
        i = i+1
      end

      #//////////////// Added for multiple subjects ////////////////////////////////
      subjectkey = params[:subject_list].values
      subvalues = Array.new
      i = 0
      while i < subjectkey.first.size-1
        subvalues.insert(i, subjectkey.first[i])
        i = i+1
      end

      #//////////////// Added for multiple subjects ////////////////////////////////


      if params[:subject_list].present?


        @displays = Search.where(:country => values).where(:subject_descriptor => subvalues)



        @displays = @displays.select("(country),(weo_country_code),(units),(iso),(weo_subject_code),(subject_descriptor),(scale),"+yearquery)  #Query testing
        #  puts @displaysyears.first
      else


        @displays = Search.where(:country => values)

      end

    else
      @displays = Search.where(:country => "")

    end
    ###################################### End of Query Section ####################################

  end


  private
  def search_params
    params.require(:search).permit(:country_name, :iso, :weo_subject_code, :weo_country_code, :country_list, :subject_list, :subject_name, :subject_descriptor, :year1, :year2,:amount)
  end

end
