New-ListView -Width 350 -Height 350 -DataBinding @{
    ItemsSource = New-Binding -IsAsync -UpdateSourceTrigger PropertyChanged -Path Output
} -View {
    New-GridView -AllowsColumnReorder -Columns {
        New-GridViewColumn "Name" 
        New-GridViewColumn "Id" 
    }
} -DataContext {
    Get-PowerShellDataSource -Script { Get-Process  }
} -On_Loaded {
    Register-PowerShellCommand -Run -In "0:0:15" -ScriptBlock {
        $window.Content.DataContext.Script = $window.Content.DataContext.Script
    }
} -asjob