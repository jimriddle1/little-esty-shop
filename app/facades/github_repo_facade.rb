class GithubRepoFacade
  def service
    GithubRepoService.new
  end

  def full_repo
    GithubRepo.new(service.repo_data)
  end

  def user_info
    Contributor.new(service.get_user_info)
  end
end
