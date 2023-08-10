class RunsController < ApplicationController
  before_action :set_run, only: %i[ show edit update destroy ]
  before_action :admin_only, except: [:log]
  before_action :admin_refresh_runs

  # GET /runs
  def index
    @runs = Run.all
    @runs = @runs.sort_by { |activity| activity[:date] }.reverse

    if(@runs.length > 0)
      @endDate = @runs.last.date
      @startDate = @runs.first.date
    end
  end

  # GET
  def multi_delete

  end

  # DELETE
  def destroy_multiple
    runs_within_date_range = Run.where(date: params[:start_date]..params[:end_date])
    runs_within_date_range.each do |run|
      run.destroy
    end
    redirect_to runlog_path
  end

  # GET /runs/calendar/:year/:month runs_calendar_path
  def calendar
    if(is_integer(params[:month]) && is_integer(params[:year]))
      @month = params[:month].to_i
      @year = params[:year].to_i
      @start_date = Date.new(@year, @month, 1)
      end_date = Date.new(@year, @month, -1)  
      @range=(@start_date..end_date).to_a

      # Put nil in calendar table spots where it should be
      @range = Array.new(@range.first.wday, nil) + @range
      @range.concat(Array.new(6 - @range.last.wday, nil))
    else
      render plain: "Invalid month and year."
    end
  end

  # GET /runs/condensed
  def condensed_view
    @runs = Run.all.order(date: :desc)
    first = @runs.first
    @start_pad_count = @runs.first.date.wday
    @start_date = first.date - @start_pad_count.days
    @runs = Array.new(@start_pad_count, nil) + @runs
  end

  # GET /runs/manager
  def manager
    @runs = Run.all.order(date: :desc)
  end

  # GET runlog_path ... /runlog
  def log
    @start = 2021
    @end = Date.today.year
    if (params[:year].present?)
        runs_in_year = Run.where("extract(year from date) = ?", params[:year])
        @average = runs_in_year.average(:distance)
        @sum = runs_in_year.sum(:distance)
        @start = params[:year].to_i
        @end = params[:year].to_i
    else
        @average = Run.average(:distance)
        @sum = Run.sum(:distance)
    end
  end

  def upload_csv
  end  

  def parse_csv
    require 'csv'
    csv_file = params[:csv_file].tempfile
    CSV.foreach(csv_file, headers: false) do |row|
      date_str = row[0] 
      distance = row[1].to_f
      date = Date.strptime(date_str, '%m/%d/%y')
      if(date != nil && distance != nil)
        run = Run.new(date: date, distance: distance)
        run.save
      end
    end
    redirect_to runs_path, notice: 'CSV file uploaded and parsed successfully.'
  end


  # GET /runs/1 or /runs/1.json
  def show
  end
  
  # GET /runs/1/edit
  def edit
  end
  
  # GET /runs/new
  def new
    @run = Run.new
  end
  
  # POST /runs/new or /runs.json
  def create
    @run = Run.new(run_params)

    respond_to do |format|
      if @run.save
        format.html { redirect_to run_url(@run), notice: "Run was successfully created." }
      else
        render plain: "failed"
      end
    end
  end

  # PATCH/PUT /runs/1 or /runs/1.json
  def update
    respond_to do |format|
      if @run.update(run_params)
        format.html { redirect_to run_url(@run), notice: "Run was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /runs/1 or /runs/1.json
  def destroy
    @run.destroy

    respond_to do |format|
      format.html { redirect_to runs_manager_url, notice: "Run was successfully destroyed." }
    end
  end

  private

    def admin_refresh_runs

    end

    # Use callbacks to share common setup or constraints between actions.
    def set_run
      @run = Run.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def run_params
      params.require(:run).permit(:date, :time, :distance)
    end

    def is_integer(i)
      i.to_i.to_s == i;
    end
end
