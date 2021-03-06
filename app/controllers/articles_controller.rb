class ArticlesController < ApplicationController
  
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  # ログインしないとArticleを作成できないようにする
  before_action :require_sign_in!, only: [:new, :create, :edit, :update, :destroy]
  # 自分以外のユーザーがeditやdestroyができないようにする
  before_action :ensure_current_user, only: [:edit, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.getArticles(signed_in?).order(params[:sort])
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    @article.writer = @current_user.name
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: '記事の作成が完了しました' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: '記事の更新が完了しました' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    if @article.writer != @current_user.name
      flash[:danger] = "権限がありません"
      redirect_to("/articles")
    end 
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: '記事の削除が完了しました' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :writer, :contents, :memberOnly, :created_at, :updated_at)
    end

    def ensure_current_user
      @article = Article.find(params[:id])
      if @article.writer != @current_user.name
        flash[:danger] = "権限がありません"
        redirect_to("/articles")
      end
    end
end
