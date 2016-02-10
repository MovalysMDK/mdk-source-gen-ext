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

<xsl:template match="dao-interface" mode="save-or-update-list">
	<xsl:variable name="interface" select="dao/interface"/>
	<xsl:variable name="class" select="dao/class"/>
	/**
	 * Sauve ou met à jour laliste d'entité <xsl:value-of select="$interface/name"/> passée en paramètre selon leur existence en base.
	 * La cascade est CascadeSet.NONE
	 * @param p_list<xsl:value-of select="$interface/name"/> une liste d'entité <xsl:value-of select="$interface/name"/>
	 * @param p_oDaoSession dao session
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void saveOrUpdateList<xsl:value-of select="$interface/name"/>( Collection&lt;<xsl:value-of select="$interface/name"/>&gt; p_list<xsl:value-of select="$interface/name"/>
			<xsl:text>, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException ;</xsl:text>

	/**
	 * Sauve ou met à jour la liste d'entité <xsl:value-of select="$interface/name"/> passée en paramètre selon leur existence en base.
	 * @param p_list<xsl:value-of select="$interface/name"/> une liste d'entité <xsl:value-of select="$interface/name"/>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oDaoSession dao session
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void saveOrUpdateList<xsl:value-of select="$interface/name"/>( Collection&lt;<xsl:value-of select="$interface/name"/>&gt; p_list<xsl:value-of select="$interface/name"/>
			<xsl:text>, CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException ;</xsl:text>
</xsl:template>



<xsl:template match="dao" mode="save-or-update-list">
	/**
	 * Sauve ou met à jour laliste d'entité <xsl:value-of select="interface/name"/> passée en paramètre selon leur existence en base.
	 * La cascade est CascadeSet.NONE
	 * @param p_list<xsl:value-of select="interface/name"/> une liste d'entité <xsl:value-of select="interface/name"/>
	 * @param p_oDaoSession dao session
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void saveOrUpdateList<xsl:value-of select="interface/name"/>( Collection&lt;<xsl:value-of select="interface/name"/>&gt; p_list<xsl:value-of select="interface/name"/>
			<xsl:text>, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {</xsl:text>
		this.saveOrUpdateList<xsl:value-of select="interface/name"/>(p_list<xsl:value-of select="interface/name"/>, CascadeSet.NONE, p_oDaoSession, p_oContext);
	}

	/**
	 * Sauve ou met à jour laliste d'entité <xsl:value-of select="interface/name"/> passée en paramètre selon leur existence en base.
	 * @param p_list<xsl:value-of select="interface/name"/> une liste d'entité <xsl:value-of select="interface/name"/>
	 * @param p_oCascadeSet ensemble de Cascades sur les entités
	 * @param p_oDaoSession dao session
	 * @param p_oContext contexte transactionnel
	 * @throws DaoException déclenchée si une exception technique survient
	 */
	public void saveOrUpdateList<xsl:value-of select="interface/name"/>( Collection&lt;<xsl:value-of select="interface/name"/>&gt; p_list<xsl:value-of select="interface/name"/>
			<xsl:text>, CascadeSet p_oCascadeSet, DaoSession p_oDaoSession, MContext p_oContext ) throws DaoException {</xsl:text>
		
		this.validateBeanList(p_list<xsl:value-of select="interface/name"/>,p_oContext);
		boolean bHaveErrorMessage = p_oContext.getMessages().hasErrors();
		
		if (!bHaveErrorMessage) {
			List&lt;<xsl:value-of select="interface/name"/>&gt; listSave = new ArrayList&lt;<xsl:value-of select="interface/name"/>&gt;();
			List&lt;<xsl:value-of select="interface/name"/>&gt; listUpdate = new ArrayList&lt;<xsl:value-of select="interface/name"/>&gt;();
			for(<xsl:value-of select="interface/name"/><xsl:text> o</xsl:text><xsl:value-of select="interface/name"/><xsl:text> : p_list</xsl:text>
				<xsl:value-of select="interface/name"/><xsl:text>) { </xsl:text>
				<xsl:if test="count(class/identifier/attribute/field/sequence) = 1">
				if(o<xsl:value-of select="interface/name"/>.<xsl:value-of select="class/identifier/attribute/get-accessor"/>() <xsl:text><![CDATA[<]]></xsl:text> 1) {
					listSave.add(o<xsl:value-of select="interface/name"/>);
				} else {
					listUpdate.add(o<xsl:value-of select="interface/name"/>);
				}</xsl:if>
			<xsl:if test="count(class/identifier/attribute/field/sequence) = 0">
				if(this.exist(o<xsl:value-of select="interface/name"/>, p_oCascadeSet, p_oContext)) {
					listUpdate.add(o<xsl:value-of select="interface/name"/>);
				} else {
					<xsl:if test="count(class/identifier/attribute) = 1 and (class/identifier/attribute[@type-name='long'] or class/identifier/attribute[@type-short-name='Long'])">
						if (o<xsl:value-of select="interface/name"/><xsl:text>.</xsl:text>
							<xsl:value-of select="class/identifier/attribute/get-accessor"/><xsl:text>() &lt; 0L</xsl:text>) {
							o<xsl:value-of select="interface/name"/>.<xsl:value-of select="class/identifier/attribute/set-accessor"/>(this.nextId());
						}
					</xsl:if>
					listSave.add(o<xsl:value-of select="interface/name"/>);
				}</xsl:if>
			<xsl:if test="count(class/identifier/attribute/field/sequence) > 1">
				<xsl:variable name="stest">
					<xsl:for-each select="class/identifier/attribute/field/sequence">
						o<xsl:value-of select="../../../../../interface/name"/>.<xsl:value-of select="../../get-accessor"/>() <xsl:text><![CDATA[< 1]]></xsl:text>
						<xsl:if test="position() != last()"><xsl:text>||</xsl:text></xsl:if></xsl:for-each>
				</xsl:variable>
				if(<xsl:value-of select="$stest"/>) {
					listSave.add(o<xsl:value-of select="interface/name"/>);
				} else {
					listUpdate.add(o<xsl:value-of select="interface/name"/>);
				}</xsl:if>
			}

			if(!listSave.isEmpty()){
				this.saveList<xsl:value-of select="interface/name"/>(listSave, p_oCascadeSet, p_oDaoSession, p_oContext);
			}
			if(!listUpdate.isEmpty()){
				this.updateList<xsl:value-of select="interface/name"/>(listUpdate, p_oCascadeSet, p_oDaoSession, p_oContext);
			}
		}
	}
</xsl:template>

</xsl:stylesheet>
