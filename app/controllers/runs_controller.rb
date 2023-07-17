class RunsController < ApplicationController
  before_action :set_run, only: %i[ show edit update destroy ]
  before_action :admin_only

  # GET /runs or /runs.json
  def index
    @runs = Run.all
    @runs = @runs.sort_by { |activity| activity[:date] }.reverse
    @endDate = @runs.last.date
    @startDate = @runs.first.date
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

  # GET /runs/new
  def new
    @run = Run.new
  end

  # GET /runs/1/edit
  def edit
  end

  # POST /runs or /runs.json
  def create
    @run = Run.new(run_params)

    respond_to do |format|
      if @run.save
        format.html { redirect_to run_url(@run), notice: "Run was successfully created." }
        format.json { render :show, status: :created, location: @run }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /runs/1 or /runs/1.json
  def update
    respond_to do |format|
      if @run.update(run_params)
        format.html { redirect_to run_url(@run), notice: "Run was successfully updated." }
        format.json { render :show, status: :ok, location: @run }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /runs/1 or /runs/1.json
  def destroy
    @run.destroy

    respond_to do |format|
      format.html { redirect_to runs_url, notice: "Run was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_run
      @run = Run.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def run_params
      params.require(:run).permit(:date, :time, :distance)
    end
end
