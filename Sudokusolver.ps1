$grid = @(
    @(0, 8, 0, 0, 0, 0, 2, 0, 0),
    @(0, 0, 0, 0, 8, 4, 0, 9, 0),
    @(0, 0, 6, 3, 2, 0, 0, 1, 0),
    @(0, 9, 7, 0, 0, 0, 0, 8, 0),
    @(8, 0, 0, 9, 0, 3, 0, 0, 2),
    @(0, 1, 0, 0, 0, 0, 9, 5, 0),
    @(0, 7, 0, 0, 4, 5, 8, 0, 0),
    @(0, 3, 0, 7, 1, 0, 0, 0, 0),
    @(0, 0, 8, 0, 0, 0, 0, 4, 0)
)
#$grid

function show-squares { 
    [CmdletBinding()]
    Param(
        [int]$sudokugrid
        )
    foreach($line in $sudokugrid) {
        write-host $line
    }
}

show-squares

function Check-Row {
    [CmdletBinding()]
    Param(
        $sudokugrid,
        [int]$row,
        [int]$candidate
        )
    if ($grid[$row] -contains $candidate){
        return $false
    }
    return $true
}

#check-row 0 8

function Check-Column {
    [CmdletBinding()]
    Param(
        $sudokugrid,
        [int]$column,
        [int]$candidate
        )
    foreach ($row in $(0..8)) {
        if ($grid[$row][$column] -eq $candidate) {
            return $false
        }
        
    }
    return $true
}

#Check-Column 0 8

#Check-Column 0 1

function Find-Square {
    [CmdletBinding()]
    param (
        $sudokugrid,
        [int]$row,
        [int]$column
    )
    $rowsquare = [math]::floor($row/3)*3
    $columnquare = [math]::floor($column/3)*3

    return @($rowsquare,$columnquare)
}
function Check-Square {
    [CmdletBinding()]
    Param(
        $sudokugrid,
        [int]$column,
        [int]$row,
        [int]$candidate
        )
    $squarecoordinates = Find-Square $row $column
    foreach ($columnaddition in $(0..2)) {
        foreach ($rowaddition in $(0..2)) {
            $rowstart, $columnstart = $squarecoordinates
            if ($grid[$rowstart + $rowaddition][$columnstart + $columnaddition] -eq $candidate) {
                return $false
            }
        }
    }
    return $true
}

#Check-Square 7 6 3
#Check-Square 7 6 4


function Check-Candidate {
    [CmdletBinding()]
    param (
        $sudokugrid,
        [int]$row,
        [int]$column,
        [int]$candidate
    )
    
    
    process {
        if ($(Check-Row $sudokugrid $row $candidate) -eq $false) {
            return $false
        }
        if ($(Check-Column $sudokugrid $column $candidate) -eq $false ){
            return $false
        } 
        if ($(Check-Square $sudokugrid $column $row $candidate) -eq $false) {
            return $false
        }
        
        return $true

    }

}

#Check-Candidate 1 6 2
$counter = 0

function Solve-Sudoku {
    [CmdletBinding()]
    param (
        $sudokugrid,
        [int]$row,
        [int]$column,
        [int]$candidate
        
    )
        
    process {
        write-host "$row, $column, $candidate"
        if ($row -gt 8) {
            write-host "done!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
            return            
        }
        if ($column -gt 8) {
            return
        }
        if ($candidate -gt 9) {
            return
        }
        if ($(Check-Candidate $sudokugrid $row $column $candidate) -eq $true) {
            #Write-host "found candidate for $row,$column = $candidate"
            $sudokugrid[$row][$column] = $candidate
            
        } else {
            Solve-Sudoku $sudokugrid $row $column $($candidate +1)
        }
        
        Solve-Sudoku $sudokugrid $row $($column + 1) 1
        Solve-Sudoku $sudokugrid $($row + 1) 0 1
        return $sudokugrid
        #show-squares $sudokugrid
        
    }

}

$solution = Solve-Sudoku $grid 0 0 1


function show-squares { 
    foreach($line in $grid) {
        write-host $line
    }
}

8,8,10
8,9,1
9,0,1


show-squares
function possible {
    [CmdletBinding()]
    Param(
        $y,
        $x,
        $n
        )
    foreach ($i in $(0..8)) {
        if ($grid[$y][$i] -eq $n) {
            return $false
        }
    }
    foreach ($i in $(0..8)) {
        if ($grid[$i][$x] -eq $n) {
            return $false
        }
    }
    $x0 = [math]::floor($x/3)*3
    $y0 = [math]::floor($y/3)*3
    foreach ($i in $(0..2)) {
        foreach ($j in $(0..2)) {
            if ($grid[$($y0+$i)][$($x0+$j)] -eq $n) {
                return $false
            }
        }

    }
    return $true
}

foreach ($i in $(0..8)) {
    foreach ($j in $(0..8)) {
        foreach ($n in $(1..9)) {
            if (possible -y $i -x $j -n $n) {
                $grid[$i][$j]
            }
            else {
                Solve-Sudoku
            }
            
        }
        
    }   
}
possible -y 0 -x 0 -n 7