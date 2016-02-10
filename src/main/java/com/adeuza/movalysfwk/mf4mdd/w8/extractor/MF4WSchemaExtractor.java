/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.w8.extractor;

import com.a2a.adjava.schema.Field;
import com.a2a.adjava.schema.SchemaFactory;
import com.a2a.adjava.schema.naming.DbNamingStrategy;
import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.xmodele.MAttribute;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele2schema.SchemaExtractor;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WEntityImpl;

public class MF4WSchemaExtractor extends SchemaExtractor{
	
	@Override
	public void extract(UmlModel p_oUmlModele) throws Exception {
		super.extract(p_oUmlModele);
		
		DbNamingStrategy oDbNamingStrategy = this.schemaConfig.getDbNamingStrategyClass();
		SchemaFactory oSchemaFactory = this.schemaConfig.getSchemaFactory();
		
		for (MEntityImpl entity : this.getDomain().getDictionnary().getAllEntities()) {
			MF4WEntityImpl mf4Entity = (MF4WEntityImpl) entity;
			if (mf4Entity.isCreateFromExpandableProcessor()) {
				String originClassName = mf4Entity.getOriginClassFromExpandableProcessor();
				for (MAttribute oAttr : entity.getAttributes()) {
					String sFieldName = oDbNamingStrategy.getColumnName(originClassName, mf4Entity.getOriginAttributeFromExpandableProcessor() + "_" + oAttr.getName());
					// Paramètres de type et mandatory non nécessaire
					Field oField = oSchemaFactory.createField(sFieldName, "", false, oAttr);
					oAttr.setField(oField);
				}
			}
		}
	}

}
