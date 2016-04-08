class SearchController < ApplicationController
  before_filter :authenticate_user!
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
        f.title(text: "#{subvalues} For " + s + " from " + params[:year1] + "-" + params[:year2])
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
        f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
        f.chart({defaultSeriesType: "scatter"})
      end


      @chart2 = LazyHighCharts::HighChart.new('graph') do |f|
        s = values.map(&:inspect).join(', ')
        f.title(text: "#{subvalues} For " + s + " from " + params[:year1] + "-" + params[:year2])
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
        f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
        f.chart({defaultSeriesType: "area"})
      end

      @chart3 = LazyHighCharts::HighChart.new('graph') do |f|
        s = values.map(&:inspect).join(', ')
        f.title(text: "#{subvalues} For " + s + " from " + params[:year1] + "-" + params[:year2])
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

            f.series(name: "#{values[i]}"+ "-" + "#{subvalues[subjectindex]}", yAxis: subjectindex, data: countryValue, type: 'column')
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
        if(summationOfValues.length == 2)
          f.series(name: "Total Summation", type: 'pie',  size: 100,  center: [900, 60], data: [{name: values[0], y: summationOfValues[0]}, {name: values[1], y: summationOfValues[1]}])
        elsif (summationOfValues.length == 4)
          f.series(name: "Total Summation", type: 'pie', size: 100,  center: [900, 60], data: [{name: values[0], y: summationOfValues[0]}, {name: values[0], y: summationOfValues[1]}, {name: values[1], y: summationOfValues[2]}, {name: values[1], y: summationOfValues[3]}])
          elsif (summationOfValues.length == 6)
          f.series(name: "Total Summation", type: 'pie', data: [{name: values[0], y: summationOfValues[0]}, {name: values[0], y: summationOfValues[1]}, {name: values[0], y: summationOfValues[2]}, {name: values[1], y: summationOfValues[3]}, {name: values[1], y: summationOfValues[4]}, {name: values[1], y: summationOfValues[5]}, center: [-50, 150]])
           else
          f.series(name: "Total Summation", type: 'pie', data: [{name: values[0], y: summationOfValues[0]}, {name: values[0], y: summationOfValues[1]}, {name: values[0], y: summationOfValues[2]}, {name: values[0], y: summationOfValues[3]}, {name: values[1], y: summationOfValues[4]}, {name: values[1], y: summationOfValues[5]}, {name: values[1], y: summationOfValues[6]}, {name: values[1], y: summationOfValues[7]}, center: [-50, 150]])
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
        f.legend(align: 'right', verticalAlign: 'top', y: 300, x: -50, layout: 'vertical')
      end
    end

########################################## End of Chart Section ########################################

  end


  private
  def search_params
    params.require(:search).permit(:country_name, :iso, :weo_subject_code, :weo_country_code, :country_list, :subject_list, :subject_name, :subject_descriptor, :year1, :year2,:amount)
  end

end
