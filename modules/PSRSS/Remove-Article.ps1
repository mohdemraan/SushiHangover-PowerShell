function Remove-Article {
    <#
    .Synopsis
    Deletes RSS articles

    .Description
    Removes articles from the RSS store

    .Parameter Article
    [Required] Specifies the articles to delete.
    Enter article objects, such as those returned by Get-Article or feed objects, such as those returned by Get-Feed.
    You can also pipe article or feed objects to Remove-Article

    .Parameter Force
    Suppresses the prompt. By default, Remove-Article prompts you before deleting the RSS feed.

    .Example
    $article  = Get-Article | where {$_.title –like "*politics*" }
    Remove-Article  $article

    .Example
    $feed  = Get-Feed "Windows PowerShell Blog"
    Remove-Article -Article $feed

    .Example
    # Deletes articles from the Windows PowerShell Blog that are more than 3 months old.
    Get-Article –feed "Windows PowerShell Blog" | Where-Object { $_.Modified –le (get-date).addmonths(-3)} | Remove-Article 

    .Notes
    Remove-Article deletes articles, but does not unsubscribe from an RSS feed. To 
    unsubscribe, use Remove-Feed.

    The Remove-Article function is exported by the PSRSS module. For more information, see about_PSRSS_Module.

    The Remove-Article function uses the Items property of Microsoft.FeedsManager objects.

    .Link
    Get-Article

    .Link
    Get-Feed

    .Link
    Remove-Feed

    .Link
    "Windows RSS Platform" in MSDN
    http://msdn.microsoft.com/en-us/library/ms684701(VS.85).aspx

    .Link
    "Microsoft.FeedsManager Object" in MSDN
    http://msdn.microsoft.com/en-us/library/ms684749(VS.85).aspx
    #>

    param(
        # The output from Get-Feed or Get-Article
        [Parameter(ValueFromPipeline=$true)]
        [ValidateScript({
            $_.PSObject.TypeNames[0] -eq "System.__ComObject#{79ac9ef4-f9c1-4d2b-a50b-a7ffba4dcf37}" -or
            $_.PSObject.TypeNames[0] -eq "System.__ComObject#{33f2ea09-1398-4ab9-b6a4-f94b49d0a42e}"
        })]
        [__ComObject]
        $Article,
        
        # If Set, will not prompt the user to continue            
        [Switch]$Force
    ) 
    
    
    Process {
        $typeName = $_.PSObject.TypeNames[0]
        switch ($TypeName) {
            "System.__ComObject#{33f2ea09-1398-4ab9-b6a4-f94b49d0a42e}" { 
                # Feed
                $article.Items | 
                    ForEach-Object { 
                        if (-not $Force) {
                            if (-not $psCmdlet.ShouldContinue(
                                $_.Parent.Name + '-' + $_.Title,
                                "Remove Article?"
                            )) {
                                return
                            }
                        }
                        $article.Delete()
                    }
            }
            "System.__ComObject#{79ac9ef4-f9c1-4d2b-a50b-a7ffba4dcf37}" {
                # Article
                if (-not $Force) {
                    if (-not $psCmdlet.ShouldContinue( 
                        $Article.Parent.Name + '-' + $Article.Title,
                        "Remove Article?"
                    )) {
                        return
                    }
                }
                $article.Delete()
            }
        }        
    }

}