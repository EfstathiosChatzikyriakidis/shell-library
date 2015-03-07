#!/bin/sh

#  $Id: libTYSP.sh, v 1.1 1999/01/05 07:24:50 ranga Exp $
#  $Id: free_lib.sh, v 1.2 2005/03/22 16:32:00 faif Exp $
#  $Id: shell-library.sh, v 1.3 2010/02/17 00:46:00 efxa Exp $

#  shell-library.sh -- A collection of useful shellscript functions.
#
#  Copyright (C) 2005 Athanasios Kasampalis <faif@gnu.org>
#  Copyright (C) 2010 Efstathios Chatzikyriakidis <contact@efxa.org>
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

##########################
# Library Shared Messages.
##########################

# File Messages.
__file_does_not_exist="The following file does not exist:"
__file_is_not_regular="The following file is not a regular one:"
__file_has_zero_data="The following file has zero size:"
__file_is_not_readable="The following file is not readable:"
__file_is_not_directory="The following file is not a directory:"

# GUI Windows' Titles.
__file_window="File Contents"
__warning_window="Warning"
__info_window="Information"
__error_window="Error"

# General Messages.
__insufficient_arguments="Call with insufficient arguments."

####################
# Library Functions.
####################

###########################################################
# Name: print_error
# Description: prints an error message to STDERR and exits.
# Arguments: $@ -> message to print.
###########################################################
print_error ()
{
    [ $# -lt 1 ] && print_error "${__insufficient_arguments}"
    echo "ERROR: ${@}" >&2
    exit 1
}

############################################################
# Name: print_warning
# Description: prints a warning message to STDERR and exits.
# Arguments: $@ -> message to print.
############################################################
print_warning () 
{
    [ $# -lt 1 ] && print_error "${__insufficient_arguments}"
    echo "WARNING: ${@}" >&2
    exit 1
}

######################################
# Name: print_info
# Description: prints an info message.
# Arguments: $@ -> message to print.
######################################
print_info () 
{
    [ $# -lt 1 ] && print_error "${__insufficient_arguments}"
    echo "INFO: ${@}"
}

################################################
# Name: print_usage
# Description: prints a usage message and exits.
# Arguments: $@ -> message to print.
################################################
print_usage ()
{
    [ $# -lt 1 ] && print_error "${__insufficient_arguments}"
    echo "USAGE: ${@}"
    exit 0
}

#############################################################
# Name: print_gui_error
# Description: prints an error message in a window and exits.
# Arguments: $1 -> message to print.
#############################################################
print_gui_error ()
{
    [ $# -lt 1 ] && print_error "${__insufficient_arguments}"
    zenity --error --title "${__error_window}" --text "$1"
    exit 1
}

##############################################################
# Name: print_gui_warning
# Description: prints a warning message in a window and exits.
# Arguments: $1 -> message to print.
##############################################################
print_gui_warning () 
{
    [ $# -lt 1 ] && print_error "${__insufficient_arguments}"
    zenity --warning --title "${__warning_window}" --text "$1"
    exit 1
}

##################################################
# Name: print_gui_info
# Description: prints an info message in a window.
# Arguments: $1 -> message to print.
##################################################
print_gui_info ()
{
    [ $# -lt 1 ] && print_error "${__insufficient_arguments}"
    zenity --info --title "${__info_window}" --text "$1"
    return 0
}

#########################################################
# Name: print_gui_file
#
# Description: prints the contents of a file in a window.
#
# Arguments: $1 -> file to print.
#            $2 -> width of the window (number).
#            $3 -> height of the window (number).
#########################################################
print_gui_file ()
{
    [ $# -lt 3 ] && print_error "${__insufficient_arguments}"

    WIDTH="$2"
    HEIGHT="$3"

    zenity --text-info                \
           --title "${__file_window}" \
           --width "$WIDTH"           \
           --height "$HEIGHT"         \
           --filename="$1"

    unset WIDTH HEIGHT
    return 0
}

###################################
# Name: new_line
# Description: prints a blank line.
###################################
new_line () 
{
    echo
    return 0
}

########################################################################
# Name: prompt_yes_no
#
# Description: ask a yes/no question.
#
# Arguments: $1 -> the prompt.
#            $2 -> the default answer (optional).
#
# Variables: YESNO -> set to the users response: y for yes and n for no.
########################################################################
prompt_yes_no ()
{
    [ $# -lt 1 ] && print_error "${__insufficient_arguments}"

    DEF_ARG=""
    YESNO=""

    case "$2" in
        [yY]|[yY][eE][sS]) 
            DEF_ARG=y ;;
        [nN]|[nN][oO]) 
            DEF_ARG=n ;;
    esac

    while :
    do
        printf "$1 (y/n)? "
        if [ -n "${DEF_ARG}" ] ; then
            printf "[${DEF_ARG}] "
        fi

        read -s -n 1 YESNO

        new_line

        if [ -z "${YESNO}" ] ; then 
            YESNO="${DEF_ARG}"
        fi

        case "${YESNO}" in 
            [yY]|[yY][eE][sS]) 
                YESNO=y ; break ;;
            [nN]|[nN][oO]) 
                YESNO=n ; break ;;
            *)
                YESNO="" ;;
        esac
    done

    export YESNO
    unset DEF_ARG
    return 0
}

###################################################
# Name: prompt_response
#
# Description: ask a question.
#
# Arguments: $1 -> the prompt.
#            $2 -> the default answer (optional).
#
# Variables: RESPONSE -> set to the users response.
###################################################
prompt_response () 
{
    [ $# -lt 1 ] && print_error "${__insufficient_arguments}"

    RESPONSE=""
    DEF_ARG="$2"

    while :
    do
        printf "$1 "

        if [ -n "${DEF_ARG}" -a "${DEF_ARG}" != "-" ] ; then 
            printf "[${DEF_ARG}] "
        fi

        read RESPONSE

        if [ -n "${RESPONSE}" ] ; then
            break
        elif [ -z "${RESPONSE}" -a -n "${DEF_ARG}" ] ; then
            RESPONSE="${DEF_ARG}"
            if [ "${RESPONSE}" = "-" ] ; then
                RESPONSE="" ;
            fi
            break
        fi
    done

    export RESPONSE
    unset DEF_ARG
    return 0
}

###########################################################
# Name: check_file
# Description: check if a file is a readable, regular file.
# Arguments: $1 -> the file to check for.
###########################################################
check_file ()
{
    [ $# -lt 1 ] && print_error "${__insufficient_arguments}"

    # check to see if the file exists.
    # check to see if the file is a regular one.
    # check to see if the file is readable.

    [ ! -e "$1" ] && print_warning "${__file_does_not_exist} '$1'."
    [ ! -f "$1" ] && print_warning "${__file_is_not_regular} '$1'."
    [ ! -r "$1" ] && print_warning "${__file_is_not_readable} '$1'."

    return 0
}

##########################################################
# Name: get_free_space
# Description: output the available space for a directory.
# Arguments: $1 -> the directory to check.
##########################################################
get_free_space () 
{
    [ $# -lt 1 ] && print_error "${__insufficient_arguments}"
    df -k "$1" | awk 'NR != 1 { print $4 }'
}

#####################################################
# Name: get_used_space
# Description: output the space used for a directory.
# Arguments: $1 -> the directory to check.
#####################################################
get_used_space () 
{
    [ $# -lt 1 ] && print_error "${__insufficient_arguments}"
    [ ! -d "$1" ] && print_error "${__file_is_not_directory} '$1'."
    du -sk "$1" | awk '{ print $1 }'
}

####################################################
# Name: is_space_available
#
# Description: returns true (0) if space available.
#
# Arguments: $1 -> the directory to check.
#            $2 -> the amount of space to check for.
#            $3 -> the units for $2 (optional).
#                      k for kilobytes.
#                      m for megabytes.
#                      g for gigabytes.
####################################################
is_space_available () 
{
    [ $# -lt 2 ] && print_error "${__insufficient_arguments}"
    [ ! -d "$1" ] && print_error "${__file_is_not_directory} '$1'."

    SPACE_MIN="$2"

    case "$3" in
        [mM]|[mM][bB])
            SPACE_MIN=`echo "$SPACE_MIN * 1024" | bc` ;;
        [gG]|[gG][bB])
            SPACE_MIN=`echo "$SPACE_MIN * 1024 * 1024" | bc` ;;
    esac
    
    if [ `get_free_space "$1"` -gt "$SPACE_MIN" ] ; then
        unset SPACE_MIN
        return 0
    fi

    unset SPACE_MIN
    return 1
}

########################################################
# Name: get_pid
# Description: outputs a list of process id matching $1.
# Arguments: $1 -> the command name to look for.
########################################################
get_pid () 
{
    [ $# -lt 1 ] && print_error "${__insufficient_arguments}"

    PSOPTS="-ef"
    ps $PSOPTS | grep "$1" | grep -v grep | awk '{ print $2 }'

    unset PSOPTS
}

##########################################
# Name: get_uid
# Description: outputs a numeric user id.
# Arguments: $1 -> a user name (optional).
##########################################
get_uid () 
{
    id -u $1
    return 0
}

###################################################
# Name: is_user_root
# Description: returns true (0) if the users UID=0.
# Arguments: $1 -> a user name (optional).
###################################################
is_user_root ()
{
    [ "`get_uid $1`" -eq 0 ] && return 0
    return 1
}

#########################################################
# Name: app_exist
# Description: returns true (0) if an application exists.
# Arguments: $1 -> application to search for.
#########################################################
app_exist ()
{
    [ $# -lt 1 ] && print_error "${__insufficient_arguments}"

    which "$1" > /dev/null 2>&1

    [ $? -eq 0 ] && return 0
    return 1
}

####################################################
# Name: to_lower
# Description: prints an input string to lower case.
# Arguments: $@ -> string to change.
####################################################
to_lower () 
{
    echo $@ | tr '[:upper:]' '[:lower:]'
}

####################################################
# Name: to_upper
# Description: prints an input string to upper case.
# Arguments: $@ -> string to change.
####################################################
to_upper () 
{
    echo $@ | tr '[:lower:]' '[:upper:]'
}

######################################################
# Name: file_to_lower
# Description: converts the input files to lower case.
# Arguments: $@ -> files to convert.
######################################################
file_to_lower () 
{
    for file in $@
    do
        tr '[:upper:]' '[:lower:]' < "$file" > "$file".lower 
        mv -i "$file".lower "$file"
    done

    return 0
}

######################################################
# Name: file_to_upper
# Description: converts the input files to upper case.
# Arguments: $@ -> files to convert.
######################################################
file_to_upper () 
{
    for file in $@
    do
        tr '[:lower:]' '[:upper:]' < "$file" > "$file".upper
        mv -i "$file".upper "$file"
    done

    return 0
}

#######################################################
# Name: rename_all_suffix
#
# Description: renames all the files with a new suffix.
#
# Arguments: $1 -> the old suffix (in example html).
#            $2 -> the new suffix (in example xhtml).
#######################################################
rename_all_suffix ()
{
    [ $# -lt 2 ] && print_error "${__insufficient_arguments}"

    OLDSUFFIX="$1"
    NEWSUFFIX="$2"

    ls *."$OLDSUFFIX" 1> /dev/null 2>&1
    if [ $? -ne 0 ] ; then
        print_warning "There are no files with the suffix \`$OLDSUFFIX'."

        unset OLDSUFFIX NEWSUFFIX
        return 1
    fi

    for file in *."$OLDSUFFIX"
    do
        NEWNAME=`echo "$file" | sed "s/${OLDSUFFIX}/${NEWSUFFIX}/"`
        mv -i "$file" "$NEWNAME"
    done

    unset OLDSUFFIX NEWSUFFIX NEWNAME
    return 0
}

#######################################################
# Name: rename_all_prefix
#
# Description: renames all the files with a new prefix.
#
# Arguments: $1 -> the old prefix.
#            $2 -> the new prefix.
#######################################################
rename_all_prefix ()
{
    OLDPREFIX="$1"
    NEWPREFIX="$2"

    ls "$OLDPREFIX"* 1> /dev/null 2>&1
    if [ $? -ne 0 ] ; then
        print_warning "There are no files with the prefix \`$OLDPREFIX'."

        unset OLDPREFIX NEWPREFIX
        return 1
    fi

    for file in "$OLDPREFIX"*
    do
        NEWNAME=`echo "$file" | sed "s/${OLDPREFIX}/${NEWPREFIX}/"`
        mv -i "$file" "$NEWNAME"
    done

    unset OLDPREFIX NEWPREFIX NEWNAME
    return 0
}

################################################
# Name: dos2posix
#
# Description: converts a list of dos formatted
#              files to the files' posix format.
#
# Arguments: $@ -> the list of files to convert.
################################################
dos2posix ()
{
    for file in "$@"
    do
        tr -d '\015' < "$file" > "$file".posix
        mv -i "$file".posix "$file"
    done

    return 0
}

##################################################
# Name: get_os_name
# Description: prints the operating system's name.
##################################################
get_os_name () 
{
    case `uname -s` in
        *BSD)
            echo bsd ;;
        Darwin)
            echo darwin ;;
        SunOS)
            case `uname -r` in
                5.*) echo solaris ;;
                  *) echo sunos ;;
            esac
            ;;
        Linux)
            echo linux ;;
        HP-UX)
            echo hpux ;;
        AIX) 
            echo aix ;;
        *) echo unknown ;;
   esac
}

################################################
# Name: os_is
#
# Description: return true (0) if the operating
#              system has the same name with $1.
#
# Arguments: $1 -> the name of os to check.
################################################
os_is () 
{
    [ $# -lt 1 ] && print_error "${__insufficient_arguments}"

    REQ=`echo $1 | tr '[:upper:]' '[:lower:]'`
    if [ "$REQ" = "`get_os_name`" ] ; then
        unset REQ
        return 0
    fi

    unset REQ
    return 1 
}

###################################################
# Name: get_chars
#
# Description: prints out the number of the
#              chars which exist in a file.
#
# Arguments: $@ -> the files to count the chars of.
###################################################
get_chars () 
{
    case `get_os_name` in
        bsd|sunos|linux)
            WCOPT="-c" ;;
        *)
            WCOPT="-m" ;;
    esac

    wc $WCOPT $@
    unset WCOPT
}

####################################################
# Name: pecho
#
# Description: prints out a string in a portable way
#              for all the POSIX operating systems.
#
# Arguments: $1 -> the string to print out.
####################################################
pecho () 
{
    _N=
    _C="\c"

    ECHOOUT=`echo "hello $_C"`
    if [ "$ECHOOUT" = "hello \c" ] ; then
        _N="-n"
        _C=
    fi

    echo $_N "$@" $_C 
    unset _N _C ECHOOUT
}
