class AtendimentosController < ApplicationController
  before_action :set_atendimento, only: %i[ show edit update destroy ]

  # GET /atendimentos or /atendimentos.json
  def index
    @atendimentos = Atendimento.all
  end

  # GET /atendimentos/1 or /atendimentos/1.json
  def show
    @atendimento = Atendimento.find(params[:id])
  end

  # GET /atendimentos/new
  def new
    @atendimento = Atendimento.new
  end

  # GET /atendimentos/1/edit
  def edit
  end

  # POST /atendimentos or /atendimentos.json
  def create
    data_hora = params[:atendimento][:data_hora]
    begin
      datetime = DateTime.parse(data_hora)
    rescue ArgumentError
      @atendimento = Atendimento.new
      @atendimento.errors.add(:data_hora, "Data e hora inválidas")
      render :new, status: :unprocessable_entity
      return
    end

    @atendimento = Atendimento.new(atendimento_params.merge(data_hora: datetime))

    if @atendimento.save
      redirect_to @atendimento, notice: 'Atendimento foi criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end


  # PATCH/PUT /atendimentos/1 or /atendimentos/1.json
  def update
    respond_to do |format|
      data_hora = params[:atendimento][:data_hora] # Ajuste para pegar o campo correto do formulário
      datetime = DateTime.parse(data_hora)

      if @atendimento.update(atendimento_params.merge(data_hora: datetime))
        format.html { redirect_to atendimento_url(@atendimento), notice: "Atendimento was successfully updated." }
        format.json { render :show, status: :ok, location: @atendimento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @atendimento.errors, status: :unprocessable_entity }
      end
    end
  end



  # DELETE /atendimentos/1 or /atendimentos/1.json
  def destroy
    @atendimento = Atendimento.find(params[:id])
    @atendimento.destroy
    redirect_to atendimentos_path, notice: "Atendimento excluido com sucesso."
  end

  def search
    @consultas = Atendimento.all

    if params[:dentist_id].present?
      dentist = Dentist.find(params[:dentist_id])
      @consultas = @consultas.where(dentist: dentist)
    end

    if params[:patient_id].present?
      patient = Patient.find(params[:patient_id])
      @consultas = @consultas.where(patient: patient)
    end

    if params[:data_hora].present?
      datetime = DateTime.parse(params[:data_hora])
      @consultas = @consultas.where(data_hora: datetime)
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_atendimento
      @atendimento = Atendimento.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
  def atendimento_params
    params.require(:atendimento).permit(:dentist_id, :patient_id, :data_hora, :data, :hora, :observacao)
  end
end
