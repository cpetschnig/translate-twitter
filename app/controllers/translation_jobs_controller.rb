class TranslationJobsController < ApplicationController
  # GET /translation_jobs
  # GET /translation_jobs.xml
  def index
    @translation_jobs = TranslationJob.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @translation_jobs }
    end
  end

  # GET /translation_jobs/1
  # GET /translation_jobs/1.xml
  def show
    @translation_job = TranslationJob.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @translation_job }
    end
  end

  # GET /translation_jobs/new
  # GET /translation_jobs/new.xml
  def new
    @translation_job = TranslationJob.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @translation_job }
    end
  end

  # GET /translation_jobs/1/edit
  def edit
    @translation_job = TranslationJob.find(params[:id])
  end

  # POST /translation_jobs
  # POST /translation_jobs.xml
  def create
    @translation_job = TranslationJob.new(params[:translation_job])

    respond_to do |format|
      if @translation_job.save
        format.html { redirect_to(@translation_job, :notice => 'TranslationJob was successfully created.') }
        format.xml  { render :xml => @translation_job, :status => :created, :location => @translation_job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @translation_job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /translation_jobs/1
  # PUT /translation_jobs/1.xml
  def update
    @translation_job = TranslationJob.find(params[:id])

    respond_to do |format|
      if @translation_job.update_attributes(params[:translation_job])
        format.html { redirect_to(@translation_job, :notice => 'TranslationJob was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @translation_job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /translation_jobs/1
  # DELETE /translation_jobs/1.xml
  def destroy
    @translation_job = TranslationJob.find(params[:id])
    @translation_job.destroy

    respond_to do |format|
      format.html { redirect_to(translation_jobs_url) }
      format.xml  { head :ok }
    end
  end
end
