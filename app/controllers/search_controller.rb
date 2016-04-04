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

    year1 = params[:year1]
    year2 = params[:year2]
    yearcount = year2.to_i - year1.to_i

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

      if params[:weo_subject_code].present?

        @displays = Search.where(:country => values).where(:subject_descriptor => params[:weo_subject_code])


        @displaysyears = @displays.select(yearquery)  #Query testing
      #  puts @displaysyears.first

        puts @displaysyears.first.data_1980
        puts @displaysyears.first.data_1981
        puts"yearrrrrrrrrrrrrrrrrrrrrrrrr"
      else


        @displays = Search.where(:country => values)

      end

    else
      @displays = Search.where(:country => "")

    end
    ###################################### End of Query Section ####################################

    ###################################### Begin of Chart Section ###################################

    if params[:weo_subject_code].present?
      @chart = LazyHighCharts::HighChart.new('graph') do |f|
        s = values.map(&:inspect).join(', ')
        f.title(text: "#{params[:weo_subject_code]} For " + s + " from 1980-1984")
        f.xAxis(categories: ["1980", "1981", "1982", "1983", "1984"])
        i = 0
        while i < values.length
          @displayByCountry = Search.select("data_1980, data_1981, data_1982, data_1983, data_1984, scale").where(:country => values[i]).where(:subject_descriptor => params[:weo_subject_code])
          countryValue = []

          j = 0;
          @displayByCountry.each do |request|
            if (j == 0)
              countryValue.push(request.data_1980.to_f)
              countryValue.push(request.data_1981.to_f)
              countryValue.push(request.data_1982.to_f)
              countryValue.push(request.data_1983.to_f)
              countryValue.push(request.data_1984.to_f)
              j = j + 1
            end
          end
          f.series(name: "#{values[i]}", yAxis: 0, data: countryValue)
          #f.series(name: "Population in Millions", yAxis: 1, data: [310, 127, 1340, 81, 65])
          scaleUnits = ""
          @displayByCountry.each do |request|
            scaleUnits = request.scale
          end

          if scaleUnits != nil
            f.yAxis [
                        {title: {text: "#{params[:weo_subject_code]} in " + scaleUnits, margin: 70}},
                    ]
          else
            f.yAxis [
                        {title: {text: "#{params[:weo_subject_code]}", margin: 70}},
                    ]
          end
          i = i + 1
        end
        f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
        f.chart({defaultSeriesType: "column"})
      end


      @chart1 = LazyHighCharts::HighChart.new('graph') do |f|
        s = values.map(&:inspect).join(', ')
        f.title(text: "#{params[:weo_subject_code]} For " + s + " from 1980-1984")
        f.xAxis(categories: ["1980", "1981", "1982", "1983", "1984"])
        i = 0
        while i < values.length
          @displayByCountry = Search.select("data_1980, data_1981, data_1982, data_1983, data_1984, scale").where(:country => values[i]).where(:subject_descriptor => params[:weo_subject_code])
          countryValue = []
          j = 0;
          @displayByCountry.each do |request|
            if (j == 0)
              countryValue.push(request.data_1980.to_f)
              countryValue.push(request.data_1981.to_f)
              countryValue.push(request.data_1982.to_f)
              countryValue.push(request.data_1983.to_f)
              countryValue.push(request.data_1984.to_f)
              j = j + 1
            end
          end

          f.series(name: "#{values[i]}", yAxis: 0, data: countryValue)
          scaleUnits = ""
          @displayByCountry.each do |request|
            scaleUnits = request.scale
          end

          if scaleUnits != nil
            f.yAxis [
                        {title: {text: "#{params[:weo_subject_code]} in " + scaleUnits, margin: 70}},
                    ]
          else
            f.yAxis [
                        {title: {text: "#{params[:weo_subject_code]}", margin: 70}},
                    ]
          end
          i = i + 1
        end
        f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
        f.chart({defaultSeriesType: "bar"})
      end

      @chart2 = LazyHighCharts::HighChart.new('graph') do |f|
        s = values.map(&:inspect).join(', ')
        f.title(text: "#{params[:weo_subject_code]} For " + s + " from 1980-1984")
        f.xAxis(categories: ["1980", "1981", "1982", "1983", "1984"])
        i = 0
        while i < values.length
          @displayByCountry = Search.select("data_1980, data_1981, data_1982, data_1983, data_1984, scale").where(:country => values[i]).where(:subject_descriptor => params[:weo_subject_code])
          countryValue = []
          j = 0;
          @displayByCountry.each do |request|
            if (j == 0)
              countryValue.push(request.data_1980.to_f)
              countryValue.push(request.data_1981.to_f)
              countryValue.push(request.data_1982.to_f)
              countryValue.push(request.data_1983.to_f)
              countryValue.push(request.data_1984.to_f)
              j = j + 1
            end
          end

          f.series(name: "#{values[i]}", yAxis: 0, data: countryValue)
          scaleUnits = ""
          @displayByCountry.each do |request|
            scaleUnits = request.scale
          end

          if scaleUnits != nil
            f.yAxis [
                        {title: {text: "#{params[:weo_subject_code]} in " + scaleUnits, margin: 70}},
                    ]
          else
            f.yAxis [
                        {title: {text: "#{params[:weo_subject_code]}", margin: 70}},
                    ]
          end
          i = i + 1
        end
        f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
        f.chart({defaultSeriesType: 'line'})
      end
    end
########################################## End of Chart Section ########################################

  end


  private
  def search_params
    params.require(:search).permit(:country_name, :iso, :weo_subject_code, :weo_country_code, :country_list, :subject_list, :subject_name, :subject_descriptor, :year1, :year2)
  end

end
