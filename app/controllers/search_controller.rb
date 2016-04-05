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

    @chosenYears = Array.new
    firstYear = params[:year1]
    firstYearinInt = firstYear.to_i
    while(year0<=yearcount)
      @chosenYears.insert(year0,firstYearinInt)
      firstYearinInt = firstYearinInt + 1
      year0 = year0 + 1
    end

    year0 = 0
    for year0 in 0..yearcount
      currentyear = year1.to_i + year0
      if year0 == 0
        yearquery = yearquery + "(data_" + currentyear.to_s + ")"
      else
        yearquery = yearquery + ","+ "(data_" + currentyear.to_s + ")"
      end

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
        @displaysyears = @displays.select("(country),(weo_country_code),(scale),(units),(iso),(weo_subject_code)," + yearquery)  #Query testing

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
        f.xAxis(categories: @chosenYears)
        i = 0
        while i < values.length
          @displayByCountry = Search.select(yearquery + ",(scale)").where(:country => values[i]).where(:subject_descriptor => subvalues)
          countryValue = []

          j = 0
          @displayByCountry.each do |request|
            if (j == 0)
              dataforYearChosen = 0
              while(dataforYearChosen < @chosenYears.length)
                String temp = ""
                temp = "data_" + @chosenYears[dataforYearChosen].to_s
                countryValue.push(request.send(temp.to_sym).to_f)
                dataforYearChosen = dataforYearChosen + 1
                end
              j = j + 1
            end
            end
          puts countryValue
          f.series(name: "#{values[i]}", yAxis: 0, data: countryValue)
          scaleUnits = ""
          @displayByCountry.each do |request|
            scaleUnits = request.scale
          end

          if scaleUnits != nil
            f.yAxis [
                        {title: {text: "#{subvalues} in " + scaleUnits, margin: 70}},
                    ]
          else
            f.yAxis [
                        {title: {text: "#{subvalues}", margin: 70}},
                    ]
          end
          i = i + 1
        end
        f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
        f.chart({defaultSeriesType: "area"})
      end
    end
########################################## End of Chart Section ########################################

  end


  private
  def search_params
    params.require(:search).permit(:country_name, :iso, :weo_subject_code, :weo_country_code, :country_list, :subject_list, :subject_name, :subject_descriptor, :year1, :year2)
  end

end
