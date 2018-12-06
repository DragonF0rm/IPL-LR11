require 'json'

class DatabaseController < ApplicationController
  include Math
  before_action :parse_params, only: :output

  def index; end

  def output
    if !@input_is_ok
      @result = 'ОШИБКА: недопустимый ввод'
    else

      db_record = Simon.find_by request: @max
      if db_record.nil?
        begin
          @correct = Array[]
          @count = 0
          factorial = 1
          i = 1

          @max.times do
            factorial *= i
            root = cbrt(factorial).round
            if factorial == root * (root - 1) * (root + 1)
              @count += 1
              @correct.push((root - 1).to_s + '*' + root.to_s + '*' + (root + 1).to_s + '=' + i.to_s + '!')
            end
            i += 1
          end

          @result = @count == 4 ? 'Гипотеза Симона выполняется' : 'Гипотеза Симона не выполняется'
        rescue FloatDomainError
          @result = 'ОШИБКА: последнее рассчитанное значение ' + (i-1).to_s + '!' + ' дальнейшие расчёты невозможны - недостаточно памяти'
        end
        Simon.create(request: @max, message: @result, data: @correct)
      else
        @result = db_record.message
        @correct = deserilize db_record.data
      end

    end
    render :output
  end

  def fulldb
    db_data = Array[]
    Simon.all.each do |row|
      max = row.request
      res = row.message
      corr = deserilize row.data
      hash = { max: max, result: res, correct: corr }
      db_data.push hash
    end
    render xml: db_data.to_xml
  end

  protected

  def parse_params
    @input_is_ok = true
    begin
      # If params[:max]=nil then Integer(nil) throws the exception too
      @max = Integer(params[:max])
      @input_is_ok = false if @max.negative?
    rescue TypeError, ArgumentError
      @input_is_ok = false
    end
  end

  def serilize arr
    str.to_json
  end

  def deserilize str
    JSON.parse str
  end
end
