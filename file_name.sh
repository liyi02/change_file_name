#!/bin/bash
#echo -e "please drag a file or input dile name \n"
#read dirPath

#d_suffix ：文件夹后缀
#sub_path ：文件夹后缀
#dir_or_file ：文件除了文件名称的路径
#real_name ：imageset之前的名称（没有后缀）
#finial_old_name ：修改前的图片名（带后缀）
#finial_real_name ：修改后的图片名（带后缀）

#找到png的后缀
suffix="png"
image_2x_suffix="@2x.png"
image_3x_suffix="@3x.png"
image_1x_suffix="@.png"
content_suffix=".json"
picture_d_suffix="imageset"

#content.json文件中字符串替换
function changeContentFile() {
    origin_name="$1"
    new_name="$2"
    contentPath="$3"
    if test "$new_name" != "_"
        then
        sed -i "" "s/$origin_name/$new_name/g" "$content_path"
    fi
}

#寻找需要替换的文件
function findFile() {
for file in `ls $1`
    do
        dir_or_file=$1"/"$file
        if test -d $dir_or_file
            then
                d_suffix=${file:0-8:8}
                #如果后缀是imageset
                if test "$d_suffix" = "$picture_d_suffix"
                    then
                    sub_path=$dir_or_file"/"
                    real_name=${dir_or_file##*/}
                    real_name=${real_name%.*}
                    before_1x_name="_"
                    before_2x_name="-"
                    before_3x_name="-"
                    finial_1x_real_name="_"
                    finial_2x_real_name="_"
                    finial_3x_real_name="_"
                    #算出改名后的名字
                    for subfile in `ls $sub_path`
                        do
                            finial_old_name=${subfile##*/}
                            finial_new_name="-"
#2x图片
                            if test "${finial_old_name:0-7:7}" = "$image_2x_suffix"
                                then
                                before_2x_name=$subfile
                                finial_new_name=$sub_path$real_name$image_2x_suffix
                                if test "$sub_path$subfile" != "$finial_new_name"
                                    then
                                    echo $sub_path$subfile
                                    finial_2x_real_name=$real_name$image_2x_suffix
                                    mv $sub_path$subfile $finial_new_name
                                fi

                            fi
#3x图片
                            if test "${finial_old_name:0-7:7}" = "$image_3x_suffix"
                                then
                                before_3x_name=$subfile
                                finial_new_name=$sub_path$real_name$image_3x_suffix
                                if test "$sub_path$subfile" != "$finial_new_name"
                                    then
                                    echo $sub_path$subfile
                                    finial_3x_real_name=$real_name$image_3x_suffix
                                    mv $sub_path$subfile $finial_new_name
                                fi

                            fi
#1x图片
                            if test "${finial_old_name:0-4:4}" = "$image_1x_suffix"
                                then
                                before_1x_name=subfile
                                finial_new_name=$sub_path$real_name$image_1x_suffix
                                if test "$sub_path$subfile" != "$finial_new_name"
                                    then
                                    echo $sub_path$subfile
                                    finial_1x_real_name=$real_name$image_1x_suffix
                                    mv $sub_path$subfile $finial_new_name
                                fi
                            fi
                    
                        done
#content.json文件
                content_path=$sub_path"Contents.json"
                changeContentFile $before_1x_name $finial_1x_real_name $content_path
                changeContentFile $before_2x_name $finial_2x_real_name $content_path
                changeContentFile $before_3x_name $finial_3x_real_name $content_path
            else
                findFile $dir_or_file
            fi
        fi
    done
}

root_dir="$1"
findFile $root_dir

