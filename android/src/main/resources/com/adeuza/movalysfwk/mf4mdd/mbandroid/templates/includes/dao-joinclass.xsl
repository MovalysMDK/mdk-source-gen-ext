<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)

    This file is part of Movalys MDK.
    Movalys MDK is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Movalys MDK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License
    along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Méthode de sauvegarde avec les valeurs en paramètre -->
<xsl:template match="dao-interface" mode="joinclass-interface">
	<xsl:variable name="interface" select="dao/interface"/>
	<xsl:variable name="class" select="dao/class"/>

	/**
	 * Sauvegarde l'entité <xsl:value-of select="$interface/name"/> avec les paramètres de la clé primaire.
	 * <xsl:for-each select="$class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 <xsl:text>&#13;</xsl:text>
	 </xsl:for-each>
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */	 
	<xsl:text>public void save</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
	<xsl:for-each select="$class/identifier/descendant::attribute">
		<xsl:value-of select="@type-short-name"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="parameter-name"/>
		<xsl:if test="position() != last()">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:for-each>
	<xsl:text>, MContext p_oContext ) throws DaoException ;</xsl:text>
</xsl:template>

<xsl:template match="dao" mode="join-class">
	<xsl:variable name="interface" select="interface"/>
	<xsl:variable name="class" select="class"/>
	
	/**
	 * Sauvegarde l'entité <xsl:value-of select="$interface/name"/> avec les paramètres de la clé primaire.
	 * <xsl:for-each select="$class/identifier/descendant::attribute">
	 * @param <xsl:value-of select="parameter-name"/> un paramètre de la clé primaire de type <xsl:value-of select="@type-short-name"/>
	 <xsl:text>&#13;</xsl:text>
	 </xsl:for-each>
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:text>public void save</xsl:text><xsl:value-of select="$interface/name"/><xsl:text>(</xsl:text>
	<xsl:for-each select="$class/identifier/descendant::attribute">
		<xsl:value-of select="@type-short-name"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="parameter-name"/>
		<xsl:if test="position() != last()">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:for-each>
	<xsl:text>, MContext p_oContext ) throws DaoException {
		</xsl:text>
					
		SqlInsert oSqlInsert = this.getInsertQuery();
		AndroidSQLiteConnection oConnection = ((MContextImpl) p_oContext).getConnection();
		MDKSQLiteStatement oStatement = oConnection.compileStatement(oSqlInsert.toSql(p_oContext));
		try {
			<xsl:for-each select="$class/identifier/descendant::attribute">
				<xsl:call-template name="jdbc-bind-insert">
					<xsl:with-param name="interface" select="$interface"/>
					<xsl:with-param name="statement">oStatement</xsl:with-param>
					<xsl:with-param name="object"><xsl:value-of select="parameter-name"/></xsl:with-param>
					<xsl:with-param name="by-value">true</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
			oStatement.executeUpdate();
		}
		finally {
			oStatement.close();
		}
	}
</xsl:template>


<!-- Méthode de sauvegarde à partir de la classe de gauche -->
<xsl:template match="dao-interface" mode="join-class-insert-from-side">
	<xsl:param name="interface"/>
	<xsl:param name="joinclass"/>
	<xsl:param name="class1"/>
	<xsl:param name="class2"/>
	<xsl:param name="asso1"/>
	<xsl:param name="asso2"/>	
	<xsl:param name="masterclass"/>
	
	/**
	 * Sauvegarde l'entité <xsl:value-of select="$interface/name"/>. 
	 * @param <xsl:text>p_</xsl:text><xsl:value-of select="$asso1/variable-name"/> une entité <xsl:value-of select="$class1/implements/interface/@name"/>
	 * @param <xsl:value-of select="$asso2/parameter-name"/> une liste d'entité <xsl:value-of select="$class2/implements/interface/@name"/>
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:text>public void </xsl:text><xsl:value-of select="$asso2/method-name"/>
	<xsl:text>(</xsl:text>
	<xsl:value-of select="$class1/implements/interface/@name"/>
	<xsl:text> p_</xsl:text>
	<xsl:value-of select="$asso1/variable-name"/>
	<xsl:text>, Collection&lt;</xsl:text>
	<xsl:value-of select="$class2/implements/interface/@name"/>
	<xsl:text>&gt; </xsl:text>
	<xsl:value-of select="$asso2/parameter-name"/>
	<xsl:text>, MContext p_oContext ) throws DaoException ;</xsl:text>
	
	/**
	 * Sauvegarde l'entité <xsl:value-of select="$interface/name"/>. 
	 * @param <xsl:text>p_</xsl:text><xsl:value-of select="$asso1/variable-name"/> une entité <xsl:value-of select="$class1/implements/interface/@name"/>
	 * @param <xsl:value-of select="$asso2/parameter-name"/> une liste d'entité <xsl:value-of select="$class2/implements/interface/@name"/>
	 * @param p_oDaoSession session Dao
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:text>public void </xsl:text><xsl:value-of select="$asso2/method-name"/>
	<xsl:text>(</xsl:text>
	<xsl:value-of select="$class1/implements/interface/@name"/>
	<xsl:text> p_</xsl:text>
	<xsl:value-of select="$asso1/variable-name"/>
	<xsl:text>, Collection&lt;</xsl:text>
	<xsl:value-of select="$class2/implements/interface/@name"/>
	<xsl:text>&gt; </xsl:text>
	<xsl:value-of select="$asso2/parameter-name"/>
	<xsl:text>, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException ;</xsl:text>
</xsl:template>

<xsl:template match="dao" mode="join-class-insert-from-side">
	<xsl:param name="class1"/>
	<xsl:param name="class2"/>
	<xsl:param name="asso1"/>
	<xsl:param name="asso2"/>

	<xsl:variable name="interface" select="interface"/>
	<xsl:variable name="joinclass" select="class"/>
	<xsl:variable name="masterclass" select="left-class"/>

	/**
	 * Sauvegarde l'entité <xsl:value-of select="$interface/name"/>.
	 * @param <xsl:text>p_</xsl:text><xsl:value-of select="$asso1/variable-name"/> une entité <xsl:value-of select="$class1/implements/interface/@name"/>
	 * @param <xsl:value-of select="$asso2/parameter-name"/> une liste d'entité <xsl:value-of select="$class2/implements/interface/@name"/>
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	<xsl:text>public void </xsl:text><xsl:value-of select="$asso2/method-name"/>
	<xsl:text>(</xsl:text>
	<xsl:value-of select="$class1/implements/interface/@name"/>
	<xsl:text> p_</xsl:text>
	<xsl:value-of select="$asso1/variable-name"/>
	<xsl:text>, Collection&lt;</xsl:text>
	<xsl:value-of select="$class2/implements/interface/@name"/>
	<xsl:text>&gt; </xsl:text>
	<xsl:value-of select="$asso2/parameter-name"/>
	<xsl:text>, MContext p_oContext ) throws DaoException {
		this.</xsl:text><xsl:value-of select="$asso2/method-name"/><xsl:text>(</xsl:text>
		<xsl:text> p_</xsl:text><xsl:value-of select="$asso1/variable-name"/><xsl:text>, </xsl:text><xsl:value-of select="$asso2/parameter-name"/>
		<xsl:text>, new DaoSession(), p_oContext );
	}</xsl:text>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Sauvegarde l'entité </xsl:text><xsl:value-of select="$interface/name"/><xsl:text>.&#13;</xsl:text>
		<xsl:text>	 * &#13;</xsl:text>
		<xsl:text>	 * @param p_</xsl:text><xsl:value-of select="$asso1/variable-name"/> une entité <xsl:value-of select="$class1/implements/interface/@name"/>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>	 * @param </xsl:text><xsl:value-of select="$asso2/parameter-name"/><xsl:text> une liste d'entité </xsl:text><xsl:value-of select="$class2/implements/interface/@name"/><xsl:text>.&#13;</xsl:text>
		<xsl:text>	 * @param p_oDaoSession session Dao.&#13;</xsl:text>
		<xsl:text>	 * @param p_oContext contexte transactionnel.&#13;</xsl:text>
		<xsl:text>	 * &#13;</xsl:text>
		<xsl:text>	 * @throws DaoException déclenchée si une exception technique survient.&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	public void </xsl:text><xsl:value-of select="$asso2/method-name"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="$class1/implements/interface/@name"/>
		<xsl:text> p_</xsl:text>
		<xsl:value-of select="$asso1/variable-name"/>
		<xsl:text>, Collection&lt;</xsl:text>
		<xsl:value-of select="$class2/implements/interface/@name"/>
		<xsl:text>&gt; </xsl:text>
		<xsl:value-of select="$asso2/parameter-name"/>
		<xsl:text>, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {&#13;&#13;</xsl:text>

		<!-- Récupération des présentes éléments sauvegardés -->
		<xsl:text>		Collection&lt;</xsl:text><xsl:value-of select="$interface/name"/>
		<xsl:text>&gt; listToDelete = this.getList</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text>By</xsl:text>
		<xsl:if test="$masterclass = $class1">
			<xsl:for-each select="$class1/identifier/descendant::attribute">
				<xsl:variable name="pos" select="position()"/>
				<xsl:value-of select="$joinclass/identifier/descendant::attribute[position() = $pos]/method-crit-name"/>
				<xsl:if test="position() != last()">
					<xsl:text>And</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="$masterclass = $class2 and $masterclass != $class1">
			<xsl:for-each select="$class1/identifier/descendant::attribute">
				<xsl:variable name="countAttrClass1" select="count($class1/identifier/descendant::attribute)"/>
				<xsl:variable name="pos" select="position() + $countAttrClass1"/>
				<xsl:value-of select="$joinclass/identifier/descendant::attribute[position() = $pos ]/method-crit-name"/>
				<xsl:if test="position() != last()">
					<xsl:text>_</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:text>( </xsl:text>
		<xsl:for-each select="$class1/identifier/descendant::attribute">
			<xsl:text>p_</xsl:text>
			<xsl:value-of select="$asso1/variable-name"/>
			<xsl:text>.</xsl:text>
			<xsl:value-of select="get-accessor"/>
			<xsl:text>()</xsl:text>
			<xsl:if test="position() != last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>, CascadeSet.NONE, new DaoSession(), p_oContext);&#13;</xsl:text>

		<xsl:text>		Collection&lt;</xsl:text><xsl:value-of select="$interface/name"/>
		<xsl:text>&gt; listToAdd = new ArrayList&lt;</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text>&gt;();&#13;&#13;</xsl:text>

		<xsl:variable name="iterator"	select="concat('iterExisting', $interface/name)"/>
		<xsl:variable name="item"		select="concat('oExisting', $interface/name)"/>

		<xsl:text>		Iterator&lt;</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text>&gt; </xsl:text>
		<xsl:value-of select="$iterator"/>
		<xsl:text> = null;&#13;</xsl:text>

		<xsl:text>		</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$item"/>
		<xsl:text> = null;&#13;</xsl:text>

		<xsl:text>		boolean bExisting = true;&#13;</xsl:text>

		<xsl:text>		for (</xsl:text>
		<xsl:value-of select="$class2/implements/interface/@name"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$asso2/variable-name"/>
		<xsl:text> : </xsl:text>
		<xsl:value-of select="$asso2/parameter-name"/>
		<xsl:text> ) {&#13;</xsl:text>

		<xsl:text>			bExisting = false;&#13;</xsl:text>
		<xsl:text>			</xsl:text>
		<xsl:value-of select="$iterator"/>
		<xsl:text> = listToDelete.iterator();&#13;</xsl:text>
		<xsl:text>			while (</xsl:text>
		<xsl:value-of select="$iterator"/>
		<xsl:text>.hasNext() &#38;&#38; !bExisting) {&#13;</xsl:text>

		<xsl:text>				</xsl:text><xsl:value-of select="$item"/><xsl:text> = </xsl:text><xsl:value-of select="$iterator"/><xsl:text>.next();&#13;</xsl:text>
		<xsl:text>				bExisting = </xsl:text>
		<xsl:if test="$masterclass = $class1">
			<xsl:for-each select="$class2/identifier/descendant::attribute">
				<xsl:variable name="countAttrClass1" select="count($class1/identifier/descendant::attribute)"/>
				<xsl:variable name="pos" select="position() + $countAttrClass1"/>
				<xsl:value-of select="$item"/>.<xsl:value-of select="$joinclass/identifier/descendant::attribute[position() = $pos]/get-accessor"/>
				<xsl:text>()</xsl:text>
				
				<xsl:variable name="assoVar2">
					<xsl:value-of select="$asso2/variable-name"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="get-accessor"/>
					<xsl:text>()</xsl:text>
				</xsl:variable>
				
				<xsl:if test="@primitif = 'true'">
					<xsl:text> == </xsl:text>
					<xsl:value-of select="$assoVar2"/> 
				</xsl:if>
				
				<xsl:if test="@primitif = 'false'">
					<xsl:text>.equals(</xsl:text>
					<xsl:value-of select="$assoVar2"/>
					<xsl:text>)</xsl:text>
				</xsl:if>

				<xsl:if test="position() != last()">
					<xsl:text>&#13;					&#38;&#38; </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>

		<xsl:if test="$masterclass = $class2 and $masterclass != $class1">
			<xsl:for-each select="$class2/identifier/descendant::attribute">
				<xsl:variable name="pos" select="position()"/>
				<xsl:value-of select="$item"/>
				
				<xsl:variable name="assoVar2">
					<xsl:value-of select="$asso2/variable-name"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="get-accessor"/>
					<xsl:text>()</xsl:text>
				</xsl:variable>
				
				<xsl:text>.</xsl:text>
				<xsl:value-of select="$joinclass/identifier/descendant::attribute[position() = $pos]/get-accessor"/>
				<xsl:text>()</xsl:text>
				
				<xsl:if test="@primitif = 'false'">
					<xsl:text>.equals(</xsl:text>
					<xsl:value-of select="$assoVar2"/>
					<xsl:text>)</xsl:text>
				</xsl:if>
				<xsl:if test="@primitif = 'true'">
					<xsl:text> == </xsl:text>
					<xsl:value-of select="$assoVar2"/>
				</xsl:if>

				<xsl:if test="$pos != last()">
					<xsl:text>&#13;					&#38;&#38; </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:text>;&#13;</xsl:text>

		<xsl:text>				if (bExisting) {&#13;</xsl:text>
		<xsl:text>					</xsl:text><xsl:value-of select="$iterator"/><xsl:text>.remove();&#13;</xsl:text>
		<xsl:text>				}&#13;</xsl:text>
		<xsl:text>			}&#13;</xsl:text>

		<xsl:text>			if (!bExisting) {&#13;</xsl:text>
		<xsl:text>				</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$asso1/variable-name"/>
		<xsl:text> = this.</xsl:text>
		<xsl:value-of select="class/pojo-factory-interface/bean-name"/>
		<xsl:text>.createInstance();&#13;</xsl:text>

		<xsl:text>				listToAdd.add(</xsl:text>
		<xsl:value-of select="$asso1/variable-name"/>
		<xsl:text>);&#13;&#13;</xsl:text>

		<!-- paramètre du constructor, ordre à respecter -->
		<xsl:if test="$masterclass = $class1">
			<xsl:for-each select="$class1/identifier/descendant::attribute">
				<xsl:text>				</xsl:text>
				<xsl:variable name="pos" select="position()"/>
				<xsl:value-of select="$asso1/variable-name"/>.<xsl:value-of select="$joinclass/identifier/descendant::attribute[position() = $pos]/set-accessor"/>(p_<xsl:value-of select="$asso1/variable-name"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="get-accessor"/>
				<xsl:text>());&#13;</xsl:text>
			</xsl:for-each>

			<xsl:for-each select="$class2/identifier/descendant::attribute">
				<xsl:text>				</xsl:text>
				<xsl:variable name="countAttrClass1" select="count($class1/identifier/descendant::attribute)"/>
				<xsl:variable name="pos" select="position() + $countAttrClass1"/>
				<xsl:value-of select="$asso1/variable-name"/>.<xsl:value-of select="$joinclass/identifier/descendant::attribute[position() = $pos]/set-accessor"/>(<xsl:value-of select="$asso2/variable-name"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="get-accessor"/>
				<xsl:text>());&#13;</xsl:text>
			</xsl:for-each>
		</xsl:if>

		<xsl:if test="$masterclass = $class2 and $masterclass != $class1">
			<xsl:text>				</xsl:text>
			<xsl:for-each select="$class2/identifier/descendant::attribute">
				<xsl:variable name="pos" select="position()"/>
				<xsl:value-of select="$asso1/variable-name"/>.<xsl:value-of select="$joinclass/identifier/descendant::attribute[position() = $pos]/set-accessor"/>(<xsl:value-of select="$asso2/variable-name"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="get-accessor"/>
				<xsl:text>());&#13;</xsl:text>
			</xsl:for-each>	

			<xsl:for-each select="$class1/identifier/descendant::attribute">
				<xsl:text>				</xsl:text>
				<xsl:variable name="countAttrClass1" select="count($class2/identifier/descendant::attribute)"/>
				<xsl:variable name="pos" select="position() + $countAttrClass1"/>
				<xsl:value-of select="$asso1/variable-name"/>.<xsl:value-of select="$joinclass/identifier/descendant::attribute[position() = $pos]/set-accessor"/>(p_<xsl:value-of select="$asso1/variable-name"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="get-accessor"/>
				<xsl:text>());&#13;</xsl:text>
			</xsl:for-each>
		</xsl:if>

		<xsl:text>			}&#13;</xsl:text>
		<xsl:text>		}&#13;&#13;</xsl:text>

		<xsl:text>		if ( !listToAdd.isEmpty() ) {&#13;</xsl:text>
		<xsl:text>			this.saveList</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text>( listToAdd, CascadeSet.NONE, p_oDaoSession, p_oContext );&#13;</xsl:text>
		<xsl:text>		}&#13;</xsl:text>

		<xsl:text>		if ( !listToDelete.isEmpty() ) {&#13;</xsl:text>
		<xsl:text>			this.deleteList</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text>( listToDelete, CascadeSet.NONE, p_oContext );&#13;</xsl:text>
		<xsl:text>		}&#13;</xsl:text>

		<xsl:text>	}</xsl:text>
	</xsl:template>

	<xsl:template match="dao" mode="joinclass-fk-2">
		<xsl:variable name="assoLeftName" select="./class/left-association/name"/>
		<xsl:variable name="assoRightName" select="./class/right-association/name"/>
		<xsl:variable name="rightClass" select="./right-class"/>
		<xsl:variable name="leftClass" select="./left-class"/>

		<xsl:variable name="assoOwner" select="$rightClass/association[@name = $assoRightName and @relation-owner = 'true' ]
			| $leftClass/association[@name = $assoLeftName and @relation-owner = 'true' ]"/>

		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Tableau de clés étrangères pour l'association </xsl:text><xsl:value-of select="$assoOwner/@name"/><xsl:text>.&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	@SuppressWarnings("unchecked")&#13;</xsl:text>
		<xsl:text>	public static final FieldType[] FK_</xsl:text>
		<xsl:value-of select="$assoOwner/@cascade-name"/>
		<xsl:text> = new FieldType[] {</xsl:text>
		<xsl:for-each select="$assoOwner/join-table/crit-fields/field">
			<xsl:text>new FieldType( </xsl:text>
			<xsl:value-of select="../../interface/name"/>
			<xsl:text>Field.</xsl:text>
			<xsl:value-of select="@name"/>
			<xsl:text>, SqlType.</xsl:text>
			<xsl:value-of select="@jdbc-type"/>
			<xsl:text>)</xsl:text>
			<xsl:if test="position() != last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
			<xsl:text>&#13;</xsl:text>
		</xsl:for-each>
		<xsl:text>	};&#13;&#13;</xsl:text>
	
		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * Tableau de clés étrangères pour l'association </xsl:text><xsl:value-of select="$assoOwner/@opposite-name"/><xsl:text>.&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	@SuppressWarnings("unchecked")&#13;</xsl:text>
		<xsl:text>	public static final FieldType[] FK_</xsl:text>
		<xsl:value-of select="$assoOwner/@opposite-cascade-name"/>
		<xsl:text> = new FieldType[] {&#13;</xsl:text>
		<xsl:for-each select="$assoOwner/join-table/key-fields/field">
			<xsl:text>			new FieldType( </xsl:text>
			<xsl:value-of select="../../interface/name"/>
			<xsl:text>Field.</xsl:text>
			<xsl:value-of select="@name"/>
			<xsl:text>, SqlType.</xsl:text>
			<xsl:value-of select="@jdbc-type"/>
			<xsl:text>)</xsl:text>
			<xsl:if test="position() != last()">
				<xsl:text>,</xsl:text>
			</xsl:if>
			<xsl:text>&#13;</xsl:text>
		</xsl:for-each>
		<xsl:text>	};&#13;&#13;</xsl:text>
	</xsl:template>
</xsl:stylesheet>
